//
//  CachedRequest.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import Foundation

class CachedRequest {

    static let cache = URLCache(memoryCapacity: 40 * 1024 * 1024,
                                diskCapacity: 512 * 1024 * 1024,
                                diskPath: "urlCache")

   static func request(url: URL, completion: @escaping (Data?, Bool)->() ) -> URLSessionTask? {
        let request = URLRequest(url: url,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 100)

        if let cacheResponse = cache.cachedResponse(for: request) {
            completion(cacheResponse.data, true)
            return nil
        } else {
            let config = URLSessionConfiguration.default

            config.urlCache = cache
            
            let session: URLSession = URLSession(configuration: config)
                        
            let task: URLSessionDataTask = session.dataTask(with: request,
                                        completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                completion(data, false)
            })
            task.resume()
            return task
        }
    }
}
