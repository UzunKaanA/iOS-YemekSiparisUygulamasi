//
//  CustomTabBarController.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 2.06.2024.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBar()
    }
    
    func setupTabBar() {
        // Set the tint color for the selected tab item
        tabBar.tintColor = UIColor.systemIndigo
        
        // Set the background color for the tab bar
        tabBar.barTintColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0) // Adjust the RGB values as needed
        
        // Customize individual tab bar items
        if let items = tabBar.items {
            items[0].title = ""
            items[0].image = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal)
            items[0].selectedImage = UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal)
            
            items[1].title = ""
            items[1].image = UIImage(systemName: "cart")?.withRenderingMode(.alwaysOriginal)
            items[1].selectedImage = UIImage(systemName: "cart.fill")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is AnasayfaViewController {
            print("Home tab selected")
        } else if viewController is SepetViewController {
            print("Cart tab selected")
        }
    }
}
