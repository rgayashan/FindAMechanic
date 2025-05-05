//
//  TabBarConfigurator.swift
//  FindAMechanic
//
//  Created by Rajitha Gayashan on 2025-05-05.
//

import UIKit

class TabBarConfigurator {
    static func configure() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        // Setup tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "splash-bg")?.withAlphaComponent(0.95)
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        // Configure Mechanic List tab
        let mechanicListVC = MechanicListViewController()
        let mechanicListNav = UINavigationController(rootViewController: mechanicListVC)
        mechanicListNav.tabBarItem = UITabBarItem(
            title: "Mechanics",
            image: UIImage(systemName: "wrench"),
            selectedImage: UIImage(systemName: "wrench.fill")
        )
        
        tabBarController.viewControllers = [mechanicListNav]
        tabBarController.modalTransitionStyle = .crossDissolve
        tabBarController.modalPresentationStyle = .fullScreen
        
        return tabBarController
    }
} 