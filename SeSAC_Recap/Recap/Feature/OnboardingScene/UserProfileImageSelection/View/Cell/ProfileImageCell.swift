//
//  ProfileImageCell.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import UIKit

class ProfileImageCell: UICollectionViewCell {
  
  @IBOutlet weak var profileImageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    configureConfigurableMethods()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    prepare(profileImage: nil, isSelected: false)
  }
  
  func prepare(profileImage: UIImage?, isSelected: Bool = false) {
    self.profileImageView?.image = profileImage
    self.profileImageView?.setHighlight(isOn: isSelected)
  }
}

extension ProfileImageCell: UICollectionViewCellConfigurable {
  func configureView() {
    backgroundColor = UIColor.clear
  }
  func configureLabel() {
  }
  func configureImageView() {
    DispatchQueue.main.async {
      self.profileImageView?.setProfileStyle()
    }
  }
}
