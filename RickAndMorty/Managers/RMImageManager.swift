//
//  ImageManager.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 18/10/2023.
//

import Foundation

// Reusability and caching
final class RMImageManager {
    static let shared = RMImageManager()
    
    //NSCache handles getting rid of cache incase of memory is getting low
    // it itakes key type and object tyupe
    private var imageDataCache = NSCache<NSString, NSData>()
    
    
    private init() {}
    
    /// Get image content with url
    /// - Parameters:
    ///   - url: Source URL
    ///   - completion: Callback
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void){
        let key = url.absoluteString as NSString
        
        if let data = imageDataCache.object(forKey: key){
           // print("Reading from Cache: \(key) ") -> If you want to check if it is reading from cache or not
            completion(.success(data as Data)) // NSData == Data | NSString == String
            return
        }
        
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            // Caching the data for the given url
            let value = data as NSData
            // It is a set
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
