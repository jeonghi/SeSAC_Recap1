//
//  AppAppearance.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit

class AppAppearance {
  
  /// 전역 설정
  static func configure() {
    configureNavigationBarAppearance()
    configureTabBarAppearance()
  }
  
  /// 내비게이션 바 전역 설정
  static func configureNavigationBarAppearance() {
    
    let navigationBarAppearance = UINavigationBar.appearance()
    
    /// 백버튼 아이콘 색상을 흰색으로 설정
    navigationBarAppearance.tintColor = ColorStyle.tintColor
    
    /// 타이틀 텍스트 속성 굵게 설정
    let titleTextAttributes: [NSAttributedString.Key: Any] = [
      .font: FontStyle.systemFont16,
      .foregroundColor: ColorStyle.tintColor
    ]
    
    navigationBarAppearance.titleTextAttributes = titleTextAttributes
  }
  
  /// 탭 바 전역 설정
  static func configureTabBarAppearance() {
    
    let tabBarAppearance = UITabBar.appearance()
    
    /// 틴트 색상 설정
    tabBarAppearance.tintColor = ColorStyle.pointColor
    tabBarAppearance.unselectedItemTintColor = ColorStyle.unpointColor
    
    /// 투명도 설정
    tabBarAppearance.isTranslucent = true
  }
}
