//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 14/10/2023.
//


// Notice the naming their are two view so the name is characterlistviewviewmodel, While this is intentional
// This is a dedicated view for the characterlist thats why the name is characterlistviewviewmodel

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
}

final class RMCharacterListViewViewModel: NSObject {
    
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    
    private var characters: [RMCharacter] = [] { // we create a single character collection
        // whenever the value of character is assigned we want to create a viewmodel
        didSet{
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageURL: URL(string: character.image))
                cellViewModels.append(viewModel)
            }
        }
    }
    
    // This is a collection of the viewmodel, we are creating a viewmodel everytime the character is updated
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    // MARK: - Fetching CharactersData
    public func fetchCharacters() {
        // the expectation is the type of data it will give, from the modal , it can be string, int also etc.
        RMService.shared.execute(.listCharacterRequests,
                                 expecting: RMGetAllCharactersResponse.self
        ) { [weak self] result in
            // Notice that there is no, completion handler
            // here we are asking the model from the api to match the model we have made , in this case it will be RMCharacter
            
            switch result{
            case .success(let responseModel):
                let results = responseModel.results
                self?.characters = results
                
                DispatchQueue.main.async { // we are doing this on the main queue or main thread because this is going to update the view
                    self?.delegate?.didLoadInitialCharacters()
                }
                //                let info = responseModel.info.next
                
                // now since when we succed we are keeping the data on model, that means we can manipulate it now
                print("Total: "+String(responseModel.info.count))
                // so "+String should not have space otherwise it will ask for a seperator
                // now we can manipulate inside the model which has info and info has count
                // the count is going to give us total number of data there is
                // model.info.count means , it will give us how many character there is in this case its 826
                //--> print("Page Result count: "+String(model.results.count))
                
                print("Example Image URL: "+String(responseModel.results.first?.image ?? "No Image"))
                print(String(describing: responseModel))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

// here we are assinging the UICollectionViewDatasource, for the colleciton view .
// while we could do in there as well, but we are keeping it clean.
extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    // Here we are asking how much number of items is the data source going to provide to our view that is colelction view
    // MARK: - UICollectionViewDelegate
    // WE are able to use this function because of the UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        // Here, we are unwrapping the charactercellviewmodel and using the cell
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath)
                as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        // MARK: Adding the viewmodel here
        // Now we are adding the ViewModel here, that is RMCharacterCollecctionViewCellViewModel
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        
        // here the withReuseIdentifieier, and the static string we made in RMCharactercollectionviewcell which is allowing us to reuse the cell. we have created in the collectionview in characterlistview file
        return cell
    }
    
    // we are dequeing the cell, which will be every single cell.
    // Now you can notive the withReuseIdentifierL:"cell" , for: indexPath
    // MARK: - UICollectionViewDelegateFlowLayout
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
