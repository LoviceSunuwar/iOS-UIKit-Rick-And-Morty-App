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
    // ------------------ Spinner --------------------------------------------------
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }() // <- Notice the () this is an anonymous closure, any thing that ends with this can be counted as closure.
    
    // ------------ CollectionView -----------------------------------------
    
    private let collectionView: UICollectionView = { // <- So the UICollectionView is basically a gridview or cardview
       let layout = UICollectionViewFlowLayout() // predefined layout manager for a collection view. It's used to configure the layout of the collection view, such as how cells are arranged and sized.
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        // The layout.sectionInset = UIIEdgeInsets provides reducing the size the of the cell
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
        
        
        setUpCollectionView()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }
    // Note that init(coder:) is the designated initializer in the NSCoding protocol. This method is used for initializing views from Interface Builder or Storyboards. If you're not planning to create instances of your view from Interface Builder, you can simply implement a fatalError as you've done, indicating that this initializer is unsupported.
    
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            //---------- Spinner Constraint ------------------
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            // this is defining the size
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            // this is defining the position, Notice, we are doing equalTo: centerXAnchor ( which is the current view or Parent)
            
            
            // --------------- Collectionview constraint ---------------------
            // Unlike the width and height, we are adding the constraint to the collection view on top, bottom, right and left
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setUpCollectionView(){
        collectionView.dataSource = viewModel // since, we have assingned on the characterlistviewviewmodel, we can assign it here.
        // So, This where we get the data to the collectionview or a particular view (e.g: tableview)

      
        
        // we area saying get rid of the spinner and show the grid we have which is collectionView
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.spinner.stopAnimating() // this is going to stop animating and hide itself
            
            self.collectionView.isHidden = false
            
            UIView.animate(withDuration: 0.4){
                self.collectionView.alpha = 1 // we are showing the opacity here
            }
        })
        collectionView.delegate = viewModel // since, we have assinged on the characterlistviewviewmodel, we are just assigning here.
        // So, The delegate is when we show the view, and user taps on one of the cell,
        // it will handle the events, like tapping the cell and going to the new screen
    }
}