//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 28/04/2023.
//

import UIKit

/// Controller to show and search Characters
final class RMCharacterViewController: UIViewController {
    
    // This is a cocoaTouch class
    // We made this cocoatouch class because it comes prebuilt with UIViewController, UITabbarController ETC..
    // Now we didnt use swift file in here because the swift file is basically empty
    // Althhough the file does end with .swfit but, the practicality is different.
    // since we require built in componenets like UIViewController we are using this cocoatouch class
    
    // Also, While creating the file, we can directly select what subclass is the file going to be and we get the option whether we are going to create a XIB file or not.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
         
        // the expectation is the type of data it will give, from the modal , it can be string, int also etc.
        RMService.shared.execute(.listCharacterRequests, expecting: RMGetAllCharactersResponse.self) { result in
            
            // here we are asking the model from the api to match the model we have made , in this case it will be RMCharacter
            
            switch result{
            case .success(let model):
                // now since when we succed we are keeping the data on model, that means we can manipulate it now
                print("Total: "+String(model.info.count))
                // so "+String should not have space otherwise it will ask for a seperator
                // now we can manipulate inside the model which has info and info has count
                // the count is going to give us total number of data there is
                // model.info.count means , it will give us how many character there is in this case its 826
                print("Page Result count: "+String(model.results.count))
                print(String(describing: model))
            case .failure(let error):
                print(String(describing: error))
            }
        }

        
    }

}


// explanation 
//        // here we are testing the api we made
//        let request = RMRequest(
//            endpoint: .character,
//            // from the pathcomponents we are going to iterate character
//            queryParameters: [URLQueryItem(name: "name", value: "rick"),
//                             URLQueryItem(name: "status", value: "alive")
//                             // Here we are adding the URLQueryItem two times since, this is an array
//                              // now once, we have 2 name and value the code we set up joining them with sepreator & will work
//
//                             ]
//        )
//        print(request.url)
//
//        // here we are saying give me the data from this url point (request made above) and what we are expecting ( since we have the model of character here we are asking for this)
//        RMService.shared.execute(request, expecting: RMCharacter.self) { result in
//            switch result {
//            case .success:
//                break
//            case .failure(let error):
//                print(String(describing: error))
//            }
//        }
