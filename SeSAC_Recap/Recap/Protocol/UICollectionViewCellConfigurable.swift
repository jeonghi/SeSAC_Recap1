//
//  UICollectionViewCellConfigurable.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import UIKit

@objc protocol UICollectionViewCellConfigurable {
  @objc optional func configureView()
  @objc optional func configureLayout()
  @objc optional func configureLabel()
  @objc optional func configureButton()
  @objc optional func configureImageView()
}

extension UICollectionViewCellConfigurable where Self: UICollectionViewCell {
  func configureConfigurableMethods(){
    configureView?()
    configureLayout?()
    configureLabel?()
    configureButton?()
    configureImageView?()
  }
}
