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
