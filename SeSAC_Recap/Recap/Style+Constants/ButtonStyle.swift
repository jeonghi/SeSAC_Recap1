//
//  ButtonStyle.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit

extension UIButton {
  func applyStyle(_ style: ButtonStyle, isEnabled: Bool) {
    self.isEnabled = isEnabled
    if isEnabled {
      // 활성화된 상태의 스타일
      self.tintColor = style.activeTintColor
      self.setTitleColor(style.activeTintColor, for: .normal)
      self.backgroundColor = style.activeBackgroundColor
      
    } else {
      // 비활성화된 상태의 스타일
      self.tintColor = style.inactiveTintColor
      self.setTitleColor(style.inactiveTintColor, for: .normal)
      self.backgroundColor = style.inactiveBackgroundColor
    }
    self.layer.cornerRadius = style.radius
    self.titleLabel?.font = style.font
  }
}

struct ButtonStyle {
  let activeTintColor: UIColor
  let activeBackgroundColor: UIColor
  let inactiveTintColor: UIColor
  let inactiveBackgroundColor: UIColor
  let font: UIFont
  let radius: CGFloat
  
  static let primary = ButtonStyle(
    activeTintColor: ColorStyle.tintColor,
    activeBackgroundColor: ColorStyle.pointColor,
    inactiveTintColor: ColorStyle.inactiveTintColor,
    inactiveBackgroundColor: ColorStyle.inactiveBackgroundColor,
    font: FontStyle.systemFont16,
    radius: 6.0
  )
}
