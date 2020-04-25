//
//  NetworkManager.swift
//  biji
//
//  Created by Yubo Qin on 4/24/20.
//  Copyright © 2020 Yubo Qin. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher

struct NetworkManager {
    
    static let baseUrl = "https://www.bing.com/HPImageArchive.aspx"
    static let imageBaseUrl = "https://bing.com"
    
    static func requestBingWallpaper(days: Int = 10, locale: String = "en-us", completion: @escaping ([ImageItem]) -> Void) {
        let params: [String: String] = [
            "format": "js",
            "idx": "0",
            "n": "\(days)",
            "locale": locale,
        ]
        AF.request(NetworkManager.baseUrl, method: .get, parameters: params).response { response in
            guard let data = response.data else {
                completion([])
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let response = try jsonDecoder.decode(ResponseItem.self, from: data)
                completion(response.images)
            } catch {
                completion([])
            }
        }
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
