//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 14/10/2023.
//

import Foundation

// Notice the naming their are two view so the name is characterlistviewviewmodel, While this is intentional
// This is a dedicated view for the characterlist thats why the name is characterlistviewviewmodel

import UIKit


final class CharacterListViewViewModel: NSObject {
    
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

// here we are assinging the UICollectionViewDatasource, for the colleciton view .
// while we could do in there as well, but we are keeping it clean.
extension CharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // We are able to use this fucntion becuase of the UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    // Here we are asking how much number of items is the data source going to provide to our view that is colelction view
    
    // WE are able to use this function because of the UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) // here the name is "cell" which is allowing us to reuse the cell. we have created in the collectionview in characterlistview file
        cell.backgroundColor = .systemGray
        return cell
    }
    
    // we are dequeing the cell, which will be every single cell.
    // Now you can notive the withReuseIdentifierL:"cell" , for: indexPath 
    
    // We are able to use this funciton because of the UICollectionViewDelegateFlowLayout
    // This function can be used to define height, width or basically the size of each cell in the view we are using
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds // getting the whole size of the screen no matter the iphone
        let width = (bounds.width-30)/2
        return CGSize(
            width: width,
            height: width * 1.43)
    }
}
