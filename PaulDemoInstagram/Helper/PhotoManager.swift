//
//  PhotoManager.swift
//  PaulStore
//
//  Created by 連振甫 on 2021/8/26.
//

import UIKit
import Foundation

class PhotoManager {
    
    static let shared = PhotoManager()
    private var imageCache = NSCache<NSURL, NSData>()
    
    func downloadImage(url:URL,completion: @escaping (UIImage?)-> Void) {
        
        guard let imageData = imageCache.object(forKey: url as NSURL)
              else {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                let image = UIImage(data: data)
                self.imageCache.setObject(data as NSData, forKey: url as NSURL)
                completion(image)
            }.resume()
            
            return
            
        }
        
        completion(UIImage(data: imageData as Data))
    }

}
