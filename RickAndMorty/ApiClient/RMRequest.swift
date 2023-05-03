//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 28/04/2023.
//

import Foundation

/// Obejct that represents a single API Call
final class RMRequest {
    
    
    /// API Constant
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    /// Desired Endpoint
    private let endpoint: RMEndpoint
    /// Query Arguments for API, if any
    private let pathComponents: Set<String>
    
    /// Constructed url for the api request in string format, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for api request in string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            
            let argumentedString = queryParameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentedString
        }
        return string
    }
    
    /// Computed and Constructed API URL
    public var url:URL? {
        return URL(string: urlString)
    }

    
    /// Desired HTTP methods
    public let httpMethod = "Get"
    // MARK: - Public
    
    
    /// Construct Request
    /// - Parameters:
    ///   - endpoint: Target Endpoints
    ///   - pathComponents: Collection of Path comonents
    ///   - queryParameters: Collection of Query Parameters
    public init( endpoint: RMEndpoint,
          pathComponents: Set<String> = [],
          queryParameters: [URLQueryItem] = []
    ){
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
   
}
