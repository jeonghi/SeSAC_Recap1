//
//  UIView+addSubviews.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/28/24.
//

import UIKit

extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach {
      addSubview($0)
    }
  }
}
