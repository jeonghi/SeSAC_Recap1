//
//  UITableViewCellConfigurable.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit

@objc protocol UITableViewCellConfigurable {
  @objc optional func configureView()
  @objc optional func configureLayout()
  @objc optional func configureLabel()
  @objc optional func configureButton()
  @objc optional func configureImageView()
}

extension UITableViewCellConfigurable where Self: UITableViewCell {
  func configureConfigurableMethods(){
    configureView?()
    configureLayout?()
    configureLabel?()
    configureButton?()
    configureImageView?()
  }
}
