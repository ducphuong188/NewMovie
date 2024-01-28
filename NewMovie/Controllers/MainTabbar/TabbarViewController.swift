//
//  TabbarViewController.swift
//  NewMovie
//
//  Created by macbook on 29/01/2024.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.scrollEdgeAppearance = .init(barAppearance: UIBarAppearance())
        let vc1 = UINavigationController(rootViewController: HomeVC())
        let vc2 = UINavigationController(rootViewController: SearchVC())
        let vc4 = UINavigationController(rootViewController: UserVC())
        let vc3 = UINavigationController(rootViewController: DownloadsVC())
        vc1.tabBarItem = UITabBarItem(title: "Trang chủ", image: UIImage(systemName: "house"), tag: 0)
        vc4.tabBarItem = UITabBarItem(title: "Tài khoản", image: UIImage(systemName: "person"), tag: 3)
        vc2.tabBarItem = UITabBarItem(title: "Tìm kiếm", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        vc3.tabBarItem = UITabBarItem(title: "Tải về", image: UIImage(systemName: "arrow.down.to.line"), tag: 2)
        tabBar.tintColor = .label
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }


}

