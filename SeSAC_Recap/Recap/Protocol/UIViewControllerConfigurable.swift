//
//  UIViewControllerConfigurable.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit

/// UIViewController 설정 관련 프로토콜
@objc protocol UIViewControllerConfigurable {
  @objc optional func configureView()
  @objc optional func configureNavigationBar()
  @objc optional func configureToolBar()
  @objc optional func configureLayout()
  @objc optional func configureLabel()
  @objc optional func configureButton()
  @objc optional func configureTableView()
  @objc optional func configureCollectionView()
  @objc optional func configureImageView()
  @objc optional func configureTextField()
  @objc optional func configureSeachBar()
  @objc optional func configureWebView()
}

extension UIViewControllerConfigurable where Self: UIViewController {
  func configureConfigurableMethods(){
    configureView?()
    configureNavigationBar?()
    configureToolBar?()
    configureLayout?()
    configureLabel?()
    configureButton?()
    configureTableView?()
    configureCollectionView?()
    configureImageView?()
    configureTextField?()
    configureSeachBar?()
    configureWebView?()
  }
}
