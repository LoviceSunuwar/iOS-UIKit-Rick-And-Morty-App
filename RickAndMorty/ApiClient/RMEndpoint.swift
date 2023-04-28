//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 28/04/2023.
//

import Foundation

/// Represents unique API Endpoints
@frozen enum RMEndpoint: String {
    /// Endpoints to get character info
    case character
    ///  Endpoints to get Locationinfo
    case location
    ///  Endpoints to get Episode info
    case episode
}
