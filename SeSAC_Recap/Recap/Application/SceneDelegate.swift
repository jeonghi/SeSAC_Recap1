//
//  SceneDelegate.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/18/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    /// 코드를 통해 앱 시작점 설정
    guard let scene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: scene)
    
    /// 조건에 따라 분기
    /// 1) 아직 프로필 설정하지 않은 경우 -> 온보딩
    /// 2) 프로필 설정한 경우 -> 메인 탭
    
    let rootViewController: UIViewController
    
    if let _ = UserDefaultManager.profileInfo.nickName {
      let mainTabSB = UIStoryboard(name: MainTabBarViewController.identifier, bundle: nil)
      let mainTabVC =  mainTabSB.instantiateViewController(withIdentifier: MainTabBarViewController.identifier)
      rootViewController = mainTabVC
    } else {
      let sb = UIStoryboard(name: OnboardingViewController.identifier, bundle: nil)
      let vc = sb.instantiateViewController(withIdentifier: OnboardingViewController.identifier)
      let nc = UINavigationController(rootViewController: vc)
      rootViewController = nc
    }
    
    window?.rootViewController = rootViewController // 특정 ViewController
    window?.makeKeyAndVisible()
  }
}
