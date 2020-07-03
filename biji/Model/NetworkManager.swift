//
//  NetworkManager.swift
//  biji
//
//  Created by Yubo Qin on 4/24/20.
//  Copyright © 2020 Yubo Qin. All rights reserved.
//

import Foundation
import Kingfisher

struct NetworkManager {
    
    static let baseUrl = "https://www.bing.com/HPImageArchive.aspx"
    static let imageBaseUrl = "https://bing.com"
    
    static func requestBingWallpaper(days: Int = 10, locale: String = "en-us", completion: @escaping ([ImageItem]) -> Void) {
        let params: [String: String] = [
            "format": "js",
            "idx": "0",
            "n": "\(days)",
            "mkt": locale,
        ]
        
        let mainAsyncCompletion: ([ImageItem]) -> Void = { imageItems in
            DispatchQueue.main.async {
                completion(imageItems)
            }
        }

        let urlComponent = NSURLComponents(string: NetworkManager.baseUrl)
        var queryItems: [URLQueryItem] = []
        for (key, val) in params {
            queryItems.append(URLQueryItem(name: key, value: val))
        }
        urlComponent?.queryItems = queryItems
        guard let url = urlComponent?.url else {
            mainAsyncCompletion([])
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                mainAsyncCompletion([])
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode), let data = data else {
                mainAsyncCompletion([])
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let response = try jsonDecoder.decode(ResponseItem.self, from: data)
                mainAsyncCompletion(response.images)
                PreferenceManager.shared.lastUpdated = Date().timeIntervalSince1970
            } catch {
                mainAsyncCompletion([])
            }
        }
        task.resume()
    }
    
    static func getImageUrl(imageUrl: String) -> String {
        return "\(NetworkManager.imageBaseUrl)\(imageUrl)"
    }
    
    static func requestImage(url: String, completion: @escaping (URL?) -> Void) {
        let cacheUrl = URL(fileURLWithPath: ImageCache.default.cachePath(forKey: url))
        if ImageCache.default.isCached(forKey: url) {
            completion(cacheUrl)
        } else {
            ImageDownloader.default.downloadImage(with: URL(string: url)!, options: nil, completionHandler: { result in
                guard let imageData = try? result.get().originalData else {
                    completion(nil)
                    return
                }
                
                ImageCache.default.storeToDisk(imageData, forKey: url, callbackQueue: .mainCurrentOrAsync, completionHandler: { result in
                    completion(cacheUrl)
                })
            })
        }
    }
    
}
