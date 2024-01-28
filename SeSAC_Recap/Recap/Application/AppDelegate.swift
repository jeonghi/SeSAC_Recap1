//
//  AppDelegate.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/18/24.
//

import UIKit
import Toast

@main
  class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    NotificationManager.manager.requestNotificationAuthorization()
    
    /// 앱 전역적으로 외형 설정
    AppAppearance.configure()
    return true
  }

  // MARK: UISceneSession Lifecycle
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  }
}
