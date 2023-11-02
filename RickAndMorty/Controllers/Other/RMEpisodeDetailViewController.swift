//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 31/10/2023.
//

import UIKit

final  class RMEpisodeDetailViewController: UIViewController {
    
    private let url:URL?
    
    init(url: URL?) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemGreen
    }
    
}
