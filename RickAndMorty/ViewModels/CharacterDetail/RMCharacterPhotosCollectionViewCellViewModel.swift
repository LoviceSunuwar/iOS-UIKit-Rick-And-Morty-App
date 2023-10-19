//
//  RMCharacterPhotosCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 19/10/2023.
//

import Foundation

final class RMCharacterPhotosCollectionViewCellViewModel {
    
    private let imageURL: URL?
    
    
    init(imageURL: URL?) {
        self.imageURL = imageURL
    }
    
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let imageURL = imageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        RMImageManager.shared.downloadImage(imageURL, completion: completion)
    }
}
