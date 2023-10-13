//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 28/04/2023.
//

import UIKit

/// Controller to show and search Characters
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        let request = RMRequest(
            endpoint: .character,
            queryParameters: [URLQueryItem(name: "name", value: "rick"),
                             URLQueryItem(name: "status", value: "alive")]
        )
        print(request.url)
        
        RMService.shared.execute(request, expecting: RMCharacter.self) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
    }

}
