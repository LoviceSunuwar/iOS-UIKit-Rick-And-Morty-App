//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 28/04/2023.
//

import Foundation

/// Obejct that represents a single API Call
/// Base Url
/// Endpoint -> RMEndpoint
/// Path Components
/// Query Parameters
///
final class RMRequest {
    
    // this will encapsulate all the data and create a single api according to the interaction like location, character and episode
    
    /// API Constant : This is the base url that we are going to add our made up url at the back
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    /// Desired Endpoint
    private let endpoint: RMEndpoint
    /// Query Arguments for API, if any
    /// Here we made it array of strings
    private let pathComponents: [String]
    // but, for now we are using array
    // Here we can also create using Set because, set contains of only unique elements so that the characters given by the user are not duplicated
    
    /// Constructed url for the api request in string format, if any
    private let queryParameters: [URLQueryItem]
    // URLQueryItem takes in name and a value in this case it would be name = rick , name being the name and rick being the value
    
    /// Constructed url for api request in string format
    private var urlString: String {
        var string = Constants.baseUrl // The string starts with baseURL mentioned above
        string += "/" // Here we are adding the backslash on the baseurl
        string += endpoint.rawValue // and after the backslash we are adding the rawvalue from endpoint
        
        if !pathComponents.isEmpty {
            // it will loop everyone of them and add a trailing slash
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            // here with the query we are adding ? instead of the backslash
            // query paramenter take in name=value&name=value
            let argumentedString = queryParameters.compactMap({
                guard let value = $0.value else {return nil} // we are unwrapping the value because the value is optional
                return "\($0.name)=\(value)"
            }).joined(separator: "&") // we are joining two name and value with the seperator &
            string += argumentedString
        }
        return string
    }
    
    /// Computed and Constructed API URL
    public var url:URL? {
        return URL(string: urlString)
    }
    // here we are returing the total api we made above
    // we made this optional becuase URL can be failable and we dont want it to fail and not recieve anything resulting in crash
    
    
    /// Desired HTTP methods
    public let httpMethod = "Get"
    //  this is the httpmethod we are defining because , we are only getting data from the api we are just using get
    // MARK: - Public
    
    
    /// Construct Request
    /// - Parameters:
    ///   - endpoint: Target Endpoints
    ///   - pathComponents: Collection of Path comonents ( Name : value = Location : Toronto )
    ///   - queryParameters: Collection of Query Parameters ( https:/ www .  somethinghere .com / endpoint ( location) / (name:value&name:value) (name: osso & location : toronto)
    public init( endpoint: RMEndpoint,
                 pathComponents: [String] = [],
                 queryParameters: [URLQueryItem] = []
    ){
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    //  it may or may not succed
    
    // So, this takes an url for parsing and attempt to get back the intialized RMRequest
    convenience init?(url: URL) {
        // getting the url string
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        // example: baseurl.com/character trimmed gives us just character
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            // example after trimming, it has character/name then its going to split them ["character", "Split"]
            
            if !components.isEmpty  { //if the components array is not nil
                let endPointString = components[0] // take the first element
                var pathComponents : [String] = [] 
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndpoint(rawValue: endPointString){
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2  {
                let endPointString = components[0]
                let queryItemsString = components[1]
                // value-name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    //Generic parameter 'ElementOfResult' could not be inferred Error: This means it does not know what type it is
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                if let rmEndpoint = RMEndpoint(rawValue: endPointString){
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}

extension RMRequest {
    static let listCharacterRequests = RMRequest(endpoint: .character)
    // here we are assignging the rmrequest endpoint to be character
}
