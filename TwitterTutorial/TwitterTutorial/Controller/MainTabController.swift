//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Grazi  Berti on 28/09/22.
//

import UIKit

class MainTabController: UITabBarController {
    //MARK: - Properties
    
    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewControllers()
    }
    
    //MARK: - Helpers
    
    func configureViewControllers() {
        let feed = FeedController()
        let nav1 = templeateNavigationController(image: UIImage(systemName: "house"), rootViewController: feed)
        
        let explore = ExploreController()
        let nav2 = templeateNavigationController(image: UIImage(systemName: "magnifyingglass"), rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templeateNavigationController(image: UIImage(systemName: "heart"), rootViewController: notifications)
        
        let conversations = ConversationsController()
        let nav4 = templeateNavigationController(image: UIImage(systemName: "envelope"), rootViewController: conversations)
        
        //set on TabBar
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }
    
    func templeateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        nav.navigationItem.largeTitleDisplayMode = .always
        return nav
    }
}
