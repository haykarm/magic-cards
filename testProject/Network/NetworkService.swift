//
//  NetworkService.swift
//  testProject
//
//  Created by Hayk Hartynyan on 11/10/19.
//  Copyright © 2019 Hayk Hartynyan. All rights reserved.
//

import Foundation
import UIKit

class NetworkService {
    static let imageCache = NSCache<NSString, UIImage>()
    
    static func getRequest(_ url: URL, _ completion: @escaping ([String: Any]?)->()) {
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(json)
            }
        }

        task.resume()
    }
    
    static func downloadImage(url: URL, completion: @escaping (UIImage?) -> ()) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
        } else {
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data, let image = UIImage(data: data)  else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }

                imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
                
            }
            task.resume()
        }
    }
}
