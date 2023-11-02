//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 02/11/2023.
//

import Foundation

// To Manage in memory session scoped API Caches,
// Hold a NSCache object, check if it is cached  and use it else make the api call

final class RMAPICacheManager {
    
    // API URL : Data <- Caching these
    
    private var cacheDictionary: [ RMEndpoint: NSCache<NSString, NSData>] = [:]
    
    
    
    private var cache = NSCache<NSString, NSData>()
    
    // since, NSCache erases on theuse of memery, we are creating multiple ones, so that we have a little control
    
    
    
    init() {
    
        setUpCache()
        
    }
    // MARK: Public
    
    public func cachedResponse(for endpoint: RMEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: RMEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    // MARK: Private
    
    private func setUpCache() {
        RMEndpoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
