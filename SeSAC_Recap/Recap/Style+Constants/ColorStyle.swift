//
//  ColorStyle.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit

enum ColorStyle {
  static let pointColor = UIColor(red: 73.0/255.0, green: 220.0/255.0, blue: 146.0/255.0, alpha: 1.0)
  static let tintColor = UIColor.white
  static let backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
  static let unpointColor = UIColor(hex: "#848484", alpha: 1.0)
  
  /// 비활성화 상태에 대한 색상
  static let inactiveTintColor = UIColor.gray
  static let inactiveBackgroundColor = UIColor.lightGray
  
  static let warningColor = UIColor.systemRed
  static let clear = UIColor.clear
}
