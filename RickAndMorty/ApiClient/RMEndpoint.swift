//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 28/04/2023.
//

import Foundation


// we have this enum as @frozen annotation 
/// Represents unique API Endpoints
@frozen enum RMEndpoint: String, Hashable, CaseIterable {
    
    // notice that we have not assigned a value to the cases
    // But, since the enum conforms to String it will have a RAW value,
    // Basically meaning that the case character the character will be a string
    
    /// Endpoints to get character info
    case character
    ///  Endpoints to get Locationinfo
    case location
    ///  Endpoints to get Episode info
    case episode
}
