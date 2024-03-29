//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 28/04/2023.
//

import Foundation

struct RMCharacter: Codable{
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
}


