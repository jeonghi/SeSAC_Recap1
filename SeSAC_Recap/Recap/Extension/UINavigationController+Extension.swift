//
//  UINavigationController+Extension.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/23/24.
//

import UIKit

extension UINavigationController {
  open override func viewWillLayoutSubviews() {
   navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
}

