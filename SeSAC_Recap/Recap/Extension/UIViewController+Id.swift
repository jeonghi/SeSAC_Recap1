//
//  UIViewController+Id.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit

extension UIViewController: ViewIdentifiable {
  static var identifier: String {
    String(describing: self)
  }
}
