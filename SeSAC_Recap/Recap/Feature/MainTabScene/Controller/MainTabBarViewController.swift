//
//  MainTabBarViewController.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit
import Then

class MainTabBarViewController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let searchVC = SearchViewController().then {
      $0.view.backgroundColor = ColorStyle.backgroundColor
      $0.tabBarItem = .init(title: "검색", image: IconStyle.magnifyingglass, selectedImage: nil)
    }
    let navVC = UINavigationController(rootViewController: searchVC)
    viewControllers?.insert(navVC, at: 0)
  }
}
