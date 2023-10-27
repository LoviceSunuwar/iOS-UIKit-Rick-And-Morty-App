//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 16/10/2023.
//

import UIKit

final class RMCharacterDetailViewViewModel {
    
    // For the section we made in detail view
    // case Iterable lets us iterate on each enum case we have
    enum SectionType {
        case photos(viewModel: RMCharacterPhotosCollectionViewCellViewModel) // associated values
        case information(viewModels: [RMCharacterInfoCollectionViewCellViewModel])
        case episodes(viewModels: [RMCharacterEpisodesCollectionViewCellViewModel])
    }
    
    public var sections: [SectionType] = []
    
    
    // MARK: Init
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
        setUpSections()
    }
    
    /*
     let id: Int
     let name: String
     let status: RMCharacterStatus
     // this is an enum that conforms to certian string being the case
     let species: String
     let type: String
     let gender: RMCharacterGender
     // this is an enum that conforms to certian string being the case
     let origin: RMOrigin
     // We created a struct for RM Origin because it is an object on JSON but we can have it mentioned here as well
     // struct RMOrigin: Codeable { let name: String, let url: String}
     // this is an struct , so we know that one struct can have another one as property as well
     let location: RMSingleLocation
     // this is an enum that conforms to certian string being the case
     let image: String
     let episode: [String]
     let url: String
     let created: String
     */
    
    private func setUpSections() {
        sections = [
            .photos(viewModel: .init(imageURL: URL(string: character.image))),
            .information(viewModels: [
                .init(type: .status , value: character.status.text),
                .init(type: .gender , value: character.gender.rawValue),
                .init(type: .type , value: character.type),
                .init(type: .species , value: character.species),
                .init(type: .origin , value: character.origin.name),
                .init(type: .location , value: character.location.name),
                .init(type: .created , value: character.created),
                .init(type: .episodeCount , value: "\(character.episode.count)"),
            ]),
            .episodes(viewModels: character.episode.compactMap ({
                return RMCharacterEpisodesCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            }))
        ]
    }
    
    public var requestURL: URL? {
        return URL(string: character.url)
    }
    
    public var title: String{
        character.name.uppercased()
    }
    
    // MARK: Photo Section Layout
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)
                                              ),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    //  MARK: Info Section
    // Grid, 2 columns where each piece is a information about the character
    public func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal( // Make changes as how you want the view
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(150)
                                              ),
            subitems: [item, item]) // how many subitems we want
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    // MARK: Episode Section
    public func createEpisodeSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75),
                                               heightDimension: .absolute(150)
                                              ),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging // make you horizontal scroll aka carousell // .countinous is smooth scroll, .grouppaging is like it goes one step at a time
        return section
    }
    
    
}
