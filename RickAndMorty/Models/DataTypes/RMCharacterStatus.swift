//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 01/05/2023.
//

import Foundation

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case `dead` = "Dead"
    case `unknown` = "unknown"
    
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
        // we are using backtick because swift may have a the same property like unknonwn on thier own
    }
}
