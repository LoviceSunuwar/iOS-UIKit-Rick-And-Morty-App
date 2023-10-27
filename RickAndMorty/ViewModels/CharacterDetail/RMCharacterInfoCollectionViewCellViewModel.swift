//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 19/10/2023.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    
    private let type: `Type`
    private let value: String
    // Since date formatter takes in a lot of memory we are creating a static, usual way
    static let dateFormatter: DateFormatter = {
        // 2017-11-04T18:48:46.250Z <- ISO Format IOSFormatter() Didnt work
        // We are creating a custom formatter
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        // 2017-11-04T18:48:46.250Z <- ISO Format IOSFormatter() Didnt work
        // We are creating a custom formatter
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    public var title: String {
        type.displayTitle
    }
    
    public var displayValue: String {
        if value.isEmpty {return "None"}
        
//        if type == .created {
//            print(value)
//        }
        
        if let date = Self.dateFormatter.date(from: value),
            type == .created { //ISO Date format
            return Self.shortDateFormatter.string(from: date)
        }
        
        return value
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    
    enum `Type` : String {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case episodeCount
        
        // Computed Property
        var tintColor: UIColor {
            switch self{
            case .status:
                return .systemMint
            case .gender:
                return .systemBlue
            case .type:
                return .systemGreen
            case .species:
                return .systemYellow
            case .origin:
                return .systemRed
            case .location:
                return .systemPurple
            case .created:
                return .systemOrange
            case .episodeCount:
                return .systemCyan
            }
        }
        
        var iconImage: UIImage? {
            switch self{
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        var displayTitle: String{
            switch self{
            case .status,
             .gender,
             .type,
             .species,
             .origin,
             .location,
             .created:
                return rawValue.uppercased()
            case .episodeCount:
                return "Episode Count"
            }
        }
    }
    
    
    
    
    init(
        type: `Type`, value: String
    ) {
        self.value = value
        self.type = type // the one we init
    }
}
