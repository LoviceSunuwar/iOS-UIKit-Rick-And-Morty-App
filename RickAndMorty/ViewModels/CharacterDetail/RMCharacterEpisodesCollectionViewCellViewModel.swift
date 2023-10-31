//
//  RMCharacterEpisodesCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 19/10/2023.
//

import Foundation
// Parallel API Call

protocol RMEpisodeDataRender {
    var episode: String {get}
    var name: String{get}
    var air_date: String {get}
}


final class RMCharacterEpisodesCollectionViewCellViewModel {
    
    private let episodeDataUrl: URL?
    
    private var isfetching = false
    
    private var dataBlock:((RMEpisodeDataRender) -> Void)?
    
    private var episode:RMEpisode? {
        
        didSet { // didset will kick off as soon as something is aassigend to episode
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
        
    }
    
    // MARK: init
    
    init(
        episodeDataUrl: URL?
    ) {
        self.episodeDataUrl = episodeDataUrl
    }
    
    // MARK: Publisher and subscriber pattern
    
    public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void){
        self.dataBlock = block
        
    }
    
    
    public func fetchEpisode() {
        guard !isfetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        guard let url = episodeDataUrl,
              let request = RMRequest(url: url) else  {
            return
        }
        
        isfetching =  true
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
}
