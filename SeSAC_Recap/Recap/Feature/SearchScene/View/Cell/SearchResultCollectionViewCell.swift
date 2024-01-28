//
//  SearchResultCollectionViewCell.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import UIKit
import Kingfisher
import Then

class SearchResultCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var likeBoundsView: UIView!
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var mallNameLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var lpriceLabel: UILabel!
  
  var tappedLikeButtonHandler: (() -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureConfigurableMethods()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    prepare(image: nil, mallName: nil, title: nil, lprice: nil, isLike: false, action: nil)
  }
  
  func prepare(image: String?, mallName: String?, title: String?, lprice: String?, isLike: Bool = false, action: (() -> Void)? = nil) {
    self.productImageView.kf.setImage(with: image?.toURL())
    self.mallNameLabel.text = mallName
    self.titleLabel.attributedText = title?.htmlToAttributedString(font: FontStyle.systemFont15, color: ColorStyle.tintColor, lineHeight: 22)
    self.lpriceLabel.text = lprice
    self.likeButton.setImage(isLike ? IconStyle.heartFill : IconStyle.heartEmpty, for: .normal)
    self.tappedLikeButtonHandler = action
  }
  
  @objc func tappedLikeButton() {
    tappedLikeButtonHandler?()
  }
}

extension SearchResultCollectionViewCell: UICollectionViewCellConfigurable {
  func configureImageView() {
    layoutIfNeeded()
    productImageView.contentMode = .scaleAspectFill
    productImageView.layer.cornerRadius = self.productImageView.frame.width/10
    
  }
  func configureView() {
    layoutIfNeeded()
    likeBoundsView.layer.cornerRadius = likeBoundsView.frame.width/2
    likeBoundsView.clipsToBounds = true
    likeBoundsView.backgroundColor = ColorStyle.tintColor
    likeBoundsView.alpha = 0.8
    likeBoundsView.layer.shadowRadius = 3
    likeBoundsView.layer.shadowColor = ColorStyle.backgroundColor.cgColor
  }
  func configureLabel() {
    mallNameLabel.do {
      $0.font = FontStyle.systemFont13
      $0.textColor = ColorStyle.tintColor
    }
    
    titleLabel.do {
      $0.font = FontStyle.systemFont15
      $0.textColor = ColorStyle.tintColor
      $0.numberOfLines = 2
    }
    
    lpriceLabel.do {
      $0.font = FontStyle.systemFont17
      $0.textColor = ColorStyle.tintColor
    }
  }
  
  func configureButton() {
    likeButton.do {
      $0.tintColor = ColorStyle.backgroundColor
      $0.backgroundColor = ColorStyle.clear
      $0.clipsToBounds = true
      $0.addTarget(self, action: #selector(tappedLikeButton), for: .touchUpInside)
    }
  }
}
