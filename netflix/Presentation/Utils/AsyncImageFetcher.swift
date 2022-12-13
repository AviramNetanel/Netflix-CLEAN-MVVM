//
//  AsyncImageFetcher.swift
//  netflix
//
//  Created by Zach Bazov on 09/09/2022.
//

import UIKit

private protocol FetcherInput {
    init()
    
    static func urlSession() -> URLSession
    
    func set(_ image: UIImage, forKey identifier: NSString)
    func remove(for identifier: NSString)
    func object(for identifier: NSString) -> UIImage?
    func load(url: URL, identifier: NSString, completion: @escaping (UIImage?) -> Void)
}

private protocol FetcherOutput {
    static var shared: AsyncImageFetcher { get }
    var cache: NSCache<NSString, UIImage> { get }
    var queue: OS_dispatch_queue_serial { get }
}

private typealias Fetcher = FetcherInput & FetcherOutput

final class AsyncImageFetcher: Fetcher {
    static var shared = AsyncImageFetcher()
    
    fileprivate(set) var cache = NSCache<NSString, UIImage>()
    fileprivate let queue = OS_dispatch_queue_serial(label: "com.netflix.utils.async-image-fetcher")
    
    internal required init() {}
    
    fileprivate static func urlSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 30
        return URLSession(configuration: config)
    }
    
    fileprivate func set(_ image: UIImage, forKey identifier: NSString) {
        cache.setObject(image, forKey: identifier)
    }
    
    func remove(for identifier: NSString) {
        cache.removeObject(forKey: identifier)
    }
    
    func object(for identifier: NSString) -> UIImage? {
        return cache.object(forKey: identifier)
    }
    
    func load(url: URL, identifier: NSString, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = object(for: identifier) {
            return queue.async { completion(cachedImage) }
        }
        
        AsyncImageFetcher.urlSession().dataTask(with: url) { [weak self] data, response, error in
            guard
                error == nil,
                let self = self,
                let httpURLResponse = response as? HTTPURLResponse,
                let mimeType = response?.mimeType,
                let data = data,
                let image = UIImage(data: data),
                httpURLResponse.statusCode == 200,
                mimeType.hasPrefix("image")
            else { return }
            self.set(image, forKey: identifier)
            self.queue.async { completion(image) }
        }.resume()
    }
}

class Item: Hashable {
    var image: UIImage!
    let url: URL!
    let identifier = UUID()
    
    init(image: UIImage, url: URL) {
        self.image = image
        self.url = url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class ImageURLProtocol: URLProtocol {
    var cancelledOrComplete: Bool = false
    var block: DispatchWorkItem!
    
    private static let queue = DispatchQueue(label: "com.apple.imageLoaderURLProtocol",
                                             qos: .background,
                                             attributes: .concurrent,
                                             autoreleaseFrequency: .workItem,
                                             target: .global(qos: .background))
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    class override func requestIsCacheEquivalent(_ aRequest: URLRequest, to bRequest: URLRequest) -> Bool {
        return false
    }
    
    final override func startLoading() {
        guard let reqURL = request.url, let urlClient = client else {
            return
        }
        
        block = DispatchWorkItem(block: {
            if self.cancelledOrComplete == false {
                let fileURL = URL(string: reqURL.absoluteString)!
                if let data = try? Data(contentsOf: fileURL) {
                    urlClient.urlProtocol(self, didLoad: data)
                    urlClient.urlProtocolDidFinishLoading(self)
                }
            }
            self.cancelledOrComplete = true
        })
        
        let time = DispatchTime.now().advanced(by: .nanoseconds(500))
        ImageURLProtocol.queue.asyncAfter(deadline: time, execute: block)
    }
    
    final override func stopLoading() {
        ImageURLProtocol.queue.async {
            if self.cancelledOrComplete == false,
               let cancelBlock = self.block {
                cancelBlock.cancel()
                self.cancelledOrComplete = true
            }
        }
    }
    
    static func urlSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [ImageURLProtocol.classForCoder()]
        return  URLSession(configuration: config)
    }
}


public class ImageCacheService {
    public static let shared = ImageCacheService()

    var placeholderImage = UIImage(systemName: "rectangle")!
    let cachedImages = NSCache<NSURL, UIImage>()
    var loadingResponses = [NSURL: [(Item, UIImage?) -> Void]]()

    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    /// - Tag: cache
    // Returns the cached image if available, otherwise asynchronously loads and caches it.
    final func load(url: NSURL, item: Item, completion: @escaping (Item, UIImage?) -> Void) {
        // Check for a cached image.
        if let cachedImage = image(url: url) {
            asynchrony {
                completion(item, cachedImage)
            }
            return
        }
        // In case there are more than one requestor for the image, we append their completion block.
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        // Go fetch the image.
        ImageURLProtocol.urlSession().dataTask(with: url as URL) { (data, response, error) in
            // Check for the error, then data and try to create the image.
            guard let responseData = data,
                  let image = UIImage(data: responseData),
                  let blocks = self.loadingResponses[url],
                  error == nil else {
                asynchrony {
                    completion(item, nil)
                }
                return
            }
            // Cache the image.
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            // Iterate over each requestor for the image and pass it back.
            for block in blocks {
                asynchrony {
                    block(item, image)
                }
                return
            }
        }.resume()
    }
}

//protocol URLImageCachable {
//    typealias CompletionHandler = (Item, UIImage?) -> Void
//    func image(for url: NSURL) -> UIImage?
//    mutating func request(_ url: NSURL, item: Item, completion: @escaping CompletionHandler)
//}
//
//final class CacheService: URLImageCachable {
//    let session = ImageURLProtocol.urlSession()
//    let cachedImages = NSCache<NSURL, UIImage>()
//    var loadingResponses = [NSURL: [(Item, UIImage?) -> Void]]()
//
//    func image(for url: NSURL) -> UIImage? {
//        return cachedImages.object(forKey: url)
//    }
//
//    func request(_ url: NSURL, item: Item, completion: @escaping CompletionHandler) {
//        if let cachedImage = image(for: url) {
//            completion(item, cachedImage)
//        }
//
//        if loadingResponses[url] != nil {
//            loadingResponses[url]?.append(completion)
//            return
//        } else {
//            loadingResponses[url] = [completion]
//        }
//
//        session.dataTask(with: url as URL) { (data, response, error) in
//            guard let responseData = data,
//                  let image = UIImage(data: responseData),
//                  let blocks = self.loadingResponses[url],
//                  error == nil else {
//                DispatchQueue.main.async {
//                    completion(item, nil)
//                }
//                return
//            }
//
//            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
//
//            for block in blocks {
//                DispatchQueue.main.async {
//                    block(item, image)
//                }
//                return
//            }
//        }.resume()
//    }
//}
