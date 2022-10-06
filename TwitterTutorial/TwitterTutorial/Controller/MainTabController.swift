//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Grazi  Berti on 28/09/22.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    //MARK: - Properties
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.layer.cornerRadius = 56 / 2
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        //logUserOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    //MARK: - API
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            configureViewControllers()
            uiTabBarSettings()
            configureUI()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("debug: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    //MARK: - Selectiors
    
    @objc
    func actionButtonTapped() {
        print(123)
    }
    //MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor,
                            paddingBottom: 64,
                            paddingRight: 16,
                            width: 56,
                            height: 56
        )
    }
    
    func configureViewControllers() {
        let feed = FeedController()
        let nav1 = templeateNavigationController(image: UIImage(systemName: "house"), rootViewController: feed)

        let explore = ExploreController()
        let nav2 = templeateNavigationController(image: UIImage(systemName: "magnifyingglass"), rootViewController: explore)

        let notifications = NotificationsController()
        let nav3 = templeateNavigationController(image: UIImage(systemName: "heart"), rootViewController: notifications)

        let conversations = ConversationsController()
        let nav4 = templeateNavigationController(image: UIImage(systemName: "envelope"), rootViewController: conversations)

        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }
    
    func templeateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        nav.navigationItem.largeTitleDisplayMode = .always
        return nav
    }
    
    func uiTabBarSettings() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        } else {
            // Fallback on earlier versions
        }
    }
}
