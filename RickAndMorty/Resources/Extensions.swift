//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 14/10/2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...){
        views.forEach({
            self.addSubview($0)
        })
    }
}

// here, we are making extending the functionality of a baseclass that apple offers,
