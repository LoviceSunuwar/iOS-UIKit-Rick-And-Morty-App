//
//  RMService.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 28/04/2023.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    
    /// Shared singleton instance
    static let shared = RMService()
    
    /// Piravtized constructor
    private init() {}
    
    
    /// Send Rick and Morty API calls
    /// - Parameters:
    ///   - request: Request Instance
    ///   - completion: callback with Data or Error
    public func execute(_ request: RMRequest, completion: @escaping () -> Void) {
        
    }
}
