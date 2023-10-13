//
//  RMSettingViewController.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 28/04/2023.
//

import UIKit
/// Controller to show and search Settings
final class RMSettingViewController: UIViewController {
    // This is a cocoaTouch class
    // We made this cocoatouch class because it comes prebuilt with UIViewController, UITabbarController ETC..
    // Now we didnt use swift file in here because the swift file is basically empty
    // Althhough the file does end with .swfit but, the practicality is different.
    // since we require built in componenets like UIViewController we are using this cocoatouch class
    
    // Also, While creating the file, we can directly select what subclass is the file going to be and we get the option whether we are going to create a XIB file or not.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
    }

}
