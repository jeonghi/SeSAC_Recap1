//
//  SearchHistoryCell.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/23/24.
//

import UIKit

class SearchHistoryCell: UITableViewCell {
  
  var tappedDeleteButtonHandler: (() -> Void)?
  @IBOutlet var contentLabel: UILabel!
  
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var searchImage: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    configureConfigurableMethods()
  }
  
  @objc func tappedDeleteButton(_ sender: UIButton){
    tappedDeleteButtonHandler?()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    prepare(content: nil, action: nil)
  }
  
  func prepare(content: String?, action: (() -> Void)?) {
    contentLabel?.text = content
    tappedDeleteButtonHandler = action
  }
}

extension SearchHistoryCell: UITableViewCellConfigurable {
  func configureLabel() {
    contentLabel.font = FontStyle.systemFont15
    contentLabel.textColor = ColorStyle.tintColor
    contentLabel.numberOfLines = 1
  }
  func configureButton() {
    deleteButton.tintColor = ColorStyle.tintColor
    deleteButton.addTarget(self, action: #selector(tappedDeleteButton), for: .touchUpInside)
  }
  func configureImageView() {
    searchImage.tintColor = ColorStyle.tintColor
  }
}
