//
//  AsyncImageFetcher.swift
//  netflix
//
//  Created by Zach Bazov on 09/09/2022.
//

import UIKit

// MARK: - AsyncImageFetcher

final class AsyncImageFetcher {
    
    static var shared = AsyncImageFetcher()
    
    private(set) var cache = NSCache<NSString, UIImage>()
    private var operations = [NSString: [(UIImage?) -> Void]]()
    private let queue = OS_dispatch_queue_serial(label: "com.netflix.utils.async-image-fetcher")
    
    private init() {}
    
    static func urlSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 30
        return URLSession(configuration: config)
    }
    
    func object(for identifier: NSString) -> UIImage? {
        return cache.object(forKey: identifier)
    }
    
    func set(_ image: UIImage, forKey identifier: NSString) {
        cache.setObject(image, forKey: identifier)
    }
    
    func remove(for identifier: NSString) {
        cache.removeObject(forKey: identifier)
    }
    
    func load(url: URL, identifier: NSString, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = object(for: identifier) {
            queue.async {
                completion(cachedImage)
            }
            return
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
            
            self.queue.async {
                completion(image)
            }
        }.resume()
    }
}
