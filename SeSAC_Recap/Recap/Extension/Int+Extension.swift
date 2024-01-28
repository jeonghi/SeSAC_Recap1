//
//  Int+Extension.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import Foundation

extension Int {
  func formatterStyle(_ numberStyle: NumberFormatter.Style) -> String? {
    let numberFommater: NumberFormatter = NumberFormatter()
    numberFommater.numberStyle = numberStyle
    return numberFommater.string(for: self)
  }
}
