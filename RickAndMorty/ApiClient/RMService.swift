//
//  RMService.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 28/04/2023.
//

// This service is the main api call point for the app

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    
    /// Shared singleton instance
    static let shared = RMService()
    
    /// Piravtized constructor
    private init() {}
    // every componenet will be forced to use the shared instance after having a private initializer
    
    enum RMServiceError: Error {
        case failedToCreateRequest
        // this error case is for the request
        case failedToGetData
        // this error case if for the data
    }
    // we are creating an enum which will give us error or conforms to data of error with different case,
    
    /// Send Rick and Morty API calls
    /// - Parameters:
    ///   - request: Request Instance
    ///   - type: Type of object we expect to get back 
    ///   - completion: callback with Data or Error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        // here, request is the one we deifined along with function,
        // and we are saying that the urlRequest (notice the small letter not a capital letter)
        // we  are assinging the request on this function while it executes everytime to have the data get and set from itself, where the data request is the one we created as a function below, that returns us request
        
        // we are checking, or also unwrapping since the urlRequest we are getting form the request func is optional ,and we are checking if there is the data or not, then we move along with the function or provide error.
       guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        //print("API Call: \(request.url?.absoluteString ?? "")")
        
        // here you can see on task that , we want data, but the other is _, basically _ means ignoring, since we do not need response but we need error. so usually dataTask takes in {data, urlresponse, error}
        // we are getting the data from the api we constructed since, urlRequest is where we passed the constructed data
        let task = URLSession.shared.dataTask(with: urlRequest) {data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            // Decode response
            // now , with do try and catch we are decoding the data
            // where we are saying basicaly do and try to decode the json with the data we have from the above dataTask we got
            
            do {
//                let json = try JSONSerialization.jsonObject(with: data)
//                print(String(describing: data))
                let result = try JSONDecoder().decode(type.self, from: data)
//                 we are doing type.self here because,we are saying that decode whatever the parameter you get with given input data from the above
                completion(.success(result))
               // print(String(describing: result))
                
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
        // this is necessary since, only after this our dataTask will start
    }
    
    
    // This is where we are getting the constructed api we made in RMRequest
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        // we are creating the variable named request and setting up as URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        // this is the httpmethod we created in RMRequest which is a get
        return request
    }
}
