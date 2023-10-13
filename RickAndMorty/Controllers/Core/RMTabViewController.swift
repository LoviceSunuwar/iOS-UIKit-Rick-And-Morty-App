//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Lovice Sunuwar on 28/04/2023.
//

import UIKit
// This is a cocoaTouch class
// We made this cocoatouch class because it comes prebuilt with UIViewController, UITabbarController ETC..
// Now we didnt use swift file in here because the swift file is basically empty
// Althhough the file does end with .swfit but, the practicality is different.
// since we require built in componenets like UIViewController we are using this cocoatouch class

// Also, While creating the file, we can directly select what subclass is the file going to be and we get the option whether we are going to create a XIB file or not.
/// Controller to house tab and root tab Controllers
final class RMTabViewController: UITabBarController {
    // Final class says that it cannot be subclassed ( it cannot be inherited)
// As you can see above the RMTabViewController conforms to UITabBarController
    //UITabbarController will contain the tab bar which basically in the bottom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // the background color is system background because , if the system is in light mode it shows white else it will show black
        setUpTabs()
    }
    
    private func setUpTabs() {
        //Private so that only this class can access it
        // if nothing is there it will be internal meaning that any other class across this app can access it.
        let characterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodeVC = RMEpisodeViewController()
        let settingVC = RMSettingViewController()
        
        // Above are the instances of the viewcontrollers of Character, location, episode, settings
        
        
        
        characterVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        episodeVC.navigationItem.largeTitleDisplayMode = .automatic
        settingVC.navigationItem.largeTitleDisplayMode = .automatic
      
        // Above, we are saying the largeTitleDisplay to be automatic
        
        let nav1 = UINavigationController(rootViewController: characterVC)
        let nav2 = UINavigationController(rootViewController: locationVC)
        let nav3 = UINavigationController(rootViewController: episodeVC)
        let nav4 = UINavigationController(rootViewController: settingVC)
        
        // Above we are assignging them on navigation bar because we want to display a navbar that will be on the top
        
        nav1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "globe"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        
        // Above we are just giving items and thier name and image
        // only after this, the tabbar label will show
   
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        // Above we are giving title property depending upon each of them.
        // the title are defined on the viewcontroller file for each
        
        setViewControllers(
            [nav1, nav2, nav3, nav4],
            animated: true
        )
        // This is the function avialable in the tabbar controller this takes a collection of viewcontroller
    }

}

