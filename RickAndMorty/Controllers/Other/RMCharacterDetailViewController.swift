//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 16/10/2023.
//

import UIKit

// Different approach of having the datasource and delegate in the controller here

class RMCharacterDetailViewController: UIViewController {
    private let viewModel: RMCharacterDetailViewViewModel
    
    
    private let detailView: RMCharacterDetailView

    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        // we need the view model here in the viewcontroller, to read the sections we created
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)) //
        addConstraints()
        
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    @objc
    private func didTapShare(){
        //share character info
    }
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}

// MARK: Extension for CollectionView

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        
        switch sectionType{
        case .photos:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        
        switch sectionType{
        case .photos(let viewModel):
            guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterPhotosCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterPhotosCollectionViewCell else {
                fatalError("Unsupported")
            }
            cell.configure(with: viewModel)
          //  cell.backgroundColor = .systemCyan
            return cell
        case .information(let viewModels):
            guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterInfoCollectionViewCell else {
                fatalError("Unsupported")
            }
            cell.configure(with: viewModels[indexPath.row])
          //  cell.backgroundColor = .systemYellow
            return cell
        case .episodes(let viewModels):
            guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodesCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodesCollectionViewCell else {
                fatalError("Unsupported")
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
          //  cell.backgroundColor = .systemBrown
            return cell
        }
       
    }
    
}
