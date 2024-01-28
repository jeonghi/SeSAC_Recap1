//
//  SearchFilterOptionCell.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/25/24.
//

import UIKit
import Then

class SearchFilterOptionCell: UICollectionViewCell {
  
  //MARK: Outlets
  @IBOutlet weak var uiView: UIView!
  @IBOutlet weak var uiLabel: UILabel!
  
  //MARK: Internal Properties
  var tappedOptionHandler: (() -> Void)?
  
  //MARK: Overridden Properties
  
  //MARK: View Lifecycle Methods
  override func awakeFromNib() {
    super.awakeFromNib()
    configureConfigurableMethods()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    prepare(content: nil, isSelected: false, action: nil)
  }
  
  //MARK: Internal Methods
  func prepare(content: String?, isSelected: Bool, action: (() -> Void)?) {
    self.uiLabel.text = content
    self.tappedOptionHandler = action
    self.updateStyle(isSelected)
  }
  
  @objc func tappedView() {
    tappedOptionHandler?()
  }
}

//MARK: Configure Methods (UI, Layout 등...)
extension SearchFilterOptionCell: UICollectionViewCellConfigurable {
  
  func configureView() {
    self.uiView.do {
      $0.layer.cornerRadius = 10
      $0.layer.borderColor = ColorStyle.tintColor.cgColor
      $0.layer.borderWidth = 1
      $0.clipsToBounds = true
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedView))
      $0.addGestureRecognizer(tapGesture)
    }
  }
  
  func configureLabel() {
    self.uiLabel.font = FontStyle.systemFont14
    self.uiLabel.textAlignment = .center
  }
  
  func updateStyle(_ isSelected: Bool){
    if isSelected {
      self.uiLabel.textColor = ColorStyle.backgroundColor /// 검정색 글씨
      self.uiLabel.backgroundColor = ColorStyle.tintColor
      self.uiView.backgroundColor = ColorStyle.tintColor /// 하얀 바탕
    } else {
      self.uiLabel.textColor = ColorStyle.tintColor /// 하얀 글씨
      self.uiLabel.backgroundColor = ColorStyle.clear
      self.uiView.backgroundColor = ColorStyle.clear /// 투명한 바탕
    }
  }
}
