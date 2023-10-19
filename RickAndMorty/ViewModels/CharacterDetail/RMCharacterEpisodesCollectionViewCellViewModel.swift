//
//  RMCharacterEpisodesCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 19/10/2023.
//

import Foundation
// Parallel API Call
final class RMCharacterEpisodesCollectionViewCellViewModel {
    
    private let episodeDataUrl: URL?
    
    init(
        episodeDataUrl: URL?
    ) {
        self.episodeDataUrl = episodeDataUrl
    }
}
