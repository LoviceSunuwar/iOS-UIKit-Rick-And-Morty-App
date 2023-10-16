//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 15/10/2023.
//

import UIKit
// THis is also a cocoatouch class
// This is like a recycler view of android


// This is a single cell for a character , we are desinging the cell here..
class RMCharacterCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterCollectionViewCell"
    // this is used in collectionview:UIcollectionview in the RMcharacterListView (on the list view)
    // we are registering this with a string, static constant, So that in future, if we have to change it we can just change it one place here
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        // the secondarysystembackground is coming form the light mode and darkmode provided by apple
        
        contentView.addSubviews(imageView, nameLabel, statusLabel)
        addConstraints()
        // this is where we are adding the subviews
        
    }
    
    required init?(coder: NSCoder){
        fatalError("Unsupported")
    } // this is required
    
    private func addConstraints(){
        // MARK: Adding constraints to the contents we have from the subviews we have created above
        // which helps us position where we want in the UIcollectionview cell
        NSLayoutConstraint.activate([
            statusLabel.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -5),
            
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -3),
            // Notice that we have the namelabel constraint equal to the statuslabel on top anchor that means we are having the view on top of the status label
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3),
            
        ])
       
        
        /*
         | Image |
         | name |
         | Status |
         */
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()// this performs any necessary clean up for the view that is to be resued
        // everytime we use it we want it to be cleared
        
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
        
        // we are reseting the the cell for reuse
    }
    
    public func configure(with viewModel: RMCharacterCollectionViewCellViewModel){
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        viewModel.fetchImage { [weak self] result in
            switch result {
            case.success(let data):
                // we are dealing the image to ui opn main thread
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                    // the image we are giving self which is from this class, since we dont want to retain the cell to stop making the memory leak
                }
                
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
    
}
