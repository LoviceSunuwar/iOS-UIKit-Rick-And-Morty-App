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
    
    func didLoadMoreCharacters(with newIndexPath: [IndexPath]) // how many cells we want to insert
        
    
    
    func didSelectCharacter(_ character: RMCharacter)
}

final class RMCharacterListViewViewModel: NSObject {
    
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    
    private var characters: [RMCharacter] = [] { // we create a single character collection
        // whenever the value of character is assigned we want to create a viewmodel
        // we are creating new viewmodels each time for each character
        didSet{
            // if we check by names then
            // if the the viewmodels of character we have already does contain we are going to skip this
            // not an ideal implmentation, we are doing this on assumption, that every character has an unique name
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageURL: URL(string: character.image))
                
                // If the viewmodel doesnt contain the new one we attempt to create then only insert it, this is after we add the hashable in
                if !cellViewModels.contains(viewModel) { // we are making sure, does not include what we created
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    // This is a collection of the viewmodel, we are creating a viewmodel everytime the character is updated
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = [] // collection of viewmodel that we have collected already
    
    
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
              //  print("Total: "+String(responseModel.info.count))
                // so "+String should not have space otherwise it will ask for a seperator
                // now we can manipulate inside the model which has info and info has count
                // the count is going to give us total number of data there is
                // model.info.count means , it will give us how many character there is in this case its 826
                //--> print("Page Result count: "+String(model.results.count))
                
              //  print("Example Image URL: "+String(responseModel.results.first?.image ?? "No Image"))
               // print(String(describing: responseModel))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    // MARK: Pagination, Addtional Data Load
    public func fetchAdditionalCharacter(url: URL) {
        guard !isLoadingMoreCharacters else { // if we called it once , we dont want to call it multiple times
            return
        }
        isLoadingMoreCharacters = true // this will make it only call once for the fetchmore on the spinner
       // print("Fetching more characters")
        
        guard let request = RMRequest(url: url) else { // it can return nil if we pass in something else like apple.com
            isLoadingMoreCharacters = false
            print("Failed to create request")
            return
        }
        RMService.shared.execute(request,
                                 expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            guard let strongSelf = self else { // Very Common technique
                return
            }
            switch result {
            case .success(let responseModel):
                //print("Pre-Update: \(strongSelf.cellViewModels.count)") // how many viewmodels we have before appending
                let moreResults = responseModel.results //get new data
                let info = responseModel.info
                strongSelf.apiInfo = info // hang to the api infor
                let originalCount = strongSelf.characters.count
               
                // To start new index or load we are doing some math below
                let newCount = moreResults.count
                let total = originalCount+newCount
                let startingIndex = total - newCount
                
                // here we are saying its goign to be an array of Indexpath from the starting index to the newcount and iterate over this where the row is the number section is 0
                // eg: [[0, 19], [0, 20], [0, 21], [0, 22], [0, 23], [0, 24], [0, 25], [0, 26], [0, 27], [0, 28], [0, 29], [0, 30], [0, 31], [0, 32], [0, 33], [0, 34], [0, 35], [0, 36], [0, 37], [0, 38]]
                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap ({
                    return IndexPath(row: $0, section: 0)
                })
               //print(indexPathToAdd)
                strongSelf.characters.append(contentsOf: moreResults) // adding on the characters
               // print("Post-Update: \(strongSelf.cellViewModels.count)") // how many viewmodels we have after appending
                
                
                // Error reason: 'attempt to insert item 38 into section 0, but there are only 38 items in section 0 after the update'
                // It means you are trying to add more than there is or what it actually exists
                
                DispatchQueue.main.async { // we are doing this on the main queue or main thread because this is going to update the view
                    strongSelf.delegate?.didLoadMoreCharacters(with: indexPathToAdd)
                    strongSelf.isLoadingMoreCharacters = false
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
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
        
        guard shouldShowLoadMoreIndicator,
        !isLoadingMoreCharacters,
              !cellViewModels.isEmpty, // If this is empty we dont need to fetch at start
        let nextURLString = apiInfo?.next, // To have the next url for the additional data
        let url = URL(string: nextURLString)
        else {
            return
        }
        // Common practices delay an action
        // This is a delay action
        // it will wait 0.2 second then goes off
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
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
              //  print("should start fetching more")
                self?.fetchAdditionalCharacter(url: url)
            }
            t.invalidate() //clean it
        }
    }
}
