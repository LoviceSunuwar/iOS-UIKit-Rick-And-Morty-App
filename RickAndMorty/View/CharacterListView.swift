//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 14/10/2023.
//

import UIKit

// This is a dedicated view just for the characterlist
/// View that handles showing the characters, laoders, etc.
class CharacterListView: UIView {

    // good rule of thumb, if you dont need it public make it private
    private let viewModel = CharacterListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }() // <- Notice the () this is an anonymous closure, any thing that ends with this can be counted as closure.
    
    private let collectionView: UICollectionView = { // <- So the UICollectionView is basically a gridview or cardview
       let layout = UICollectionViewFlowLayout() // predefined layout manager for a collection view. It's used to configure the layout of the collection view, such as how cells are arranged and sized.
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) //create a UICollectionView instance named collectionView. You initialize it with a frame of .zero, which means the collection view has no initial size and will be determined by its superview's constraints. You also set the collectionViewLayout to the layout you created in the previous step.
        
        collectionView.alpha = 0 // <- this a opacity
        
        collectionView.isHidden = true // first we show the spinner , we dont want to show this view until we get the data
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        //This line registers a default UICollectionViewCell class for use with the collection view. When you later dequeue cells, you can use the "cell" identifier to reuse cells with this default class.
        //Dequeueing cells in the context of a UICollectionView means to obtain a reusable cell that can be used to display content in the collection view. This process is essential for efficient memory usage and performance when dealing with a large number of cells.
        
        return collectionView
        
    }()
// MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        //common practice when working with Auto Layout in UIKit (iOS app development). It's used to indicate that you want to control the view's layout constraints manually rather than relying on the old Autoresizing Mask system.
        //you're telling UIKit not to automatically convert the view's frame-based layout (based on the frame property) into constraints. Instead, you will provide your own layout constraints to define how the view should be positioned and sized within its superview.
        
        
        addSubviews(collectionView, spinner) // <- this is the base extension for addSubview we made in the extension
        
        // -------- Here is the Spinner Part -----------------
        
        addConstraints() // you should always have it defined whatever is that you want to show in the view.
        spinner.startAnimating()
        
        // -------- calling the fucntion from view model. since we have the viewModel defined above -------------
        viewModel.fetchCharacters()
        // This is the function we have to fetch the data
        
    }
    
    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }
    // Note that init(coder:) is the designated initializer in the NSCoding protocol. This method is used for initializing views from Interface Builder or Storyboards. If you're not planning to create instances of your view from Interface Builder, you can simply implement a fatalError as you've done, indicating that this initializer is unsupported.
    
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            // this is defining the size
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            // this is defining the position, Notice, we are doing equalTo: centerXAnchor ( which is the current view or Parent)
        ])
    }
    
}
