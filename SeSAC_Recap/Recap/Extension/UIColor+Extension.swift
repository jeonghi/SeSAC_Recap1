//
//  UIColor+Extension.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit

extension UIColor {
  convenience init?(hex: String, alpha: CGFloat = 1.0) {
    var sanitizedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    sanitizedHex = sanitizedHex.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    
    Scanner(string: sanitizedHex).scanHexInt64(&rgb)
    
    let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgb & 0x0000FF) / 255.0
    
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
