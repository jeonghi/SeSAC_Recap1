//
//  UICollectionVieCell+Id.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import UIKit

extension UICollectionViewCell: ViewIdentifiable {
  static var identifier: String {
    String(describing: self)
  }
}
