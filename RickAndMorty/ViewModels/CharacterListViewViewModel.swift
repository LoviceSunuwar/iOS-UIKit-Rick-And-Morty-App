//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 14/10/2023.
//

import Foundation

// Notice the naming their are two view so the name is characterlistviewviewmodel, While this is intentional
// This is a dedicated view for the characterlist thats why the name is characterlistviewviewmodel



struct CharacterListViewViewModel {
    func fetchCharacters() {
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
