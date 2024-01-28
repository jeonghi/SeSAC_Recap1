//
//  TitleCell.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit

class TitleCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  
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
    self.prepare(titleText: nil)
  }
  
  func prepare(titleText: String?) {
    self.titleLabel?.text = titleText
  }
}

extension TitleCell: UITableViewCellConfigurable {
  
  func configureView() {
    backgroundColor = ColorStyle.tintColor.withAlphaComponent(0.1)
  }
  
  func configureLabel() {
    titleLabel = titleLabel.then {
      $0.font = FontStyle.systemFont14
      $0.textColor = ColorStyle.tintColor
    }
  }
}
