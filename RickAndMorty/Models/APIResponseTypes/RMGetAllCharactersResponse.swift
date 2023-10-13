//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 13/10/2023.
//

import Foundation


struct RMGetAllCharactersResponse: Codable {
    struct Info: Codable {
        // notice we have the capital I for the Info here in struct
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    let info: Info
    let results: [RMCharacter]
}


// notaion of paging is that the api will only give us 20 items at a time so that , we can have more to load as the user goes in bottom and bottom

