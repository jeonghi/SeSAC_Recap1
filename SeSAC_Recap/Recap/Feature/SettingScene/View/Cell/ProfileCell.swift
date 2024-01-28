//
//  ProfileCell.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit
import Then

class ProfileCell: UITableViewCell {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    configureConfigurableMethods()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    prepare(profileImage: nil, titleText: nil, supplementText: nil)
  }
  
  func prepare(profileImage: UIImage?, titleText: String?, supplementText: String?) {
    self.profileImageView.image = profileImage
    self.titleLabel.text = titleText
    self.descLabel.text = supplementText
  }
}

extension ProfileCell: UITableViewCellConfigurable {
  func configureView() {
    backgroundColor = ColorStyle.tintColor.withAlphaComponent(0.1)
  }
  func configureLabel() {
    titleLabel = titleLabel.then {
      $0.font = FontStyle.systemFont17
      $0.textColor = ColorStyle.tintColor
    }
    descLabel = descLabel.then {
      $0.font = FontStyle.systemFont13
      $0.textColor = ColorStyle.tintColor
    }
  }
  func configureImageView() {
    profileImageView = profileImageView.then {
      $0.setProfileStyle()
      $0.setHighlight(isOn: true)
    }
  }
}
