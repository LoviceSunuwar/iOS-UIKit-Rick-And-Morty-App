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
    // MARK: Delegate Pattern
    
    func didSelectCharacter(_ character: RMCharacter)
}

final class RMCharacterListViewViewModel: NSObject {
    
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    
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
    
    
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    
    // MARK: - Fetching CharactersData (Intial)
    // fethc inital character (20)
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
                let info = responseModel.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async { // we are doing this on the main queue or main thread because this is going to update the view
                    self?.delegate?.didLoadInitialCharacters()
                }
                
                
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
    
    // MARK: Pagination, Addtional Data Load
    public func fetchAdditionalCharacter() {
        isLoadingMoreCharacters = true // this will make it only call once for the fetchmore on the spinner
    }
    
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
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
    
    // MARK: Data source link of the footer, the function to deque the footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Adding the spinner to show at the bottom
        guard kind == UICollectionView.elementKindSectionFooter,
             let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath) as? RMFooterLoadingCollectionReusableView
                 else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    // MARK: Size for the footer (referencesizeforfooterinsection)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero // if we shouldnt show this the we are going to make the size zero that is basically hides it
        }
        
        return CGSize(width: collectionView.frame.width,
                      height: 100)
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row] // So, this indexpath is an inbound argumented so we get what we tapped on
        delegate?.didSelectCharacter(character)
    }
}


// MARK: ScrollView

extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingMoreCharacters else {
            return
        }
        let offset = scrollView.contentOffset.y // Increases as we go down
        let totalContentHeight = scrollView.contentSize.height // height fo the content we are getting inside the scrollview
        let totalScrollViewFixedHeight = scrollView.frame.size.height // height of the whole frame that the scrollview is in
        
        // So the logic here is,
        // the offset basically means the Y vertical axis of the scrollview, which increases as we scroll down,
        // because , we are adding in more content as we scrolldown and increasing the offset
        //But, if the offset, when scroll at the very bottom and the content view slightly goes up
        // Then we are comparing the actual contentheight we have to the frame or the scrollviewfixed heigh lets say,
        // if our offset increases then we will fetch additional data
        // we are substracting 120 because thatst the height of spinner
        if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
            print("should start fetching more")
            fetchAdditionalCharacter()
            
            
        }
    }
}
