//
//  SearchHistoryCell.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/23/24.
//

import UIKit
import Then
import SnapKit

class SearchHistoryCell: UITableViewCell {
  
  var tappedDeleteButtonHandler: (() -> Void)?
  
  var contentLabel: UILabel = .init().then {
    $0.font = FontStyle.systemFont15
    $0.textColor = ColorStyle.tintColor
    $0.numberOfLines = 1
    $0.textAlignment = .left
  }
  
  var deleteButton: UIButton = .init().then {
    $0.setImage(IconStyle.xmark, for: .normal)
    $0.tintColor = ColorStyle.tintColor
    $0.clipsToBounds = true
  }
  
  var searchImage: UIImageView = .init(image: IconStyle.magnifyingglass).then {
    $0.tintColor = ColorStyle.tintColor
    $0.clipsToBounds = true
    $0.layer.cornerRadius = $0.frame.width/2
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureConfigurableMethods()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    contentLabel.text = content
    tappedDeleteButtonHandler = action
  }
}

extension SearchHistoryCell: UITableViewCellConfigurable {
  
  func configureButton() {
    deleteButton.addTarget(self, action: #selector(tappedDeleteButton), for: .touchUpInside)
  }
  
  func configureLayout() {
    contentView.do {
      $0.addSubviews([searchImage, contentLabel, deleteButton])
    }
    
    searchImage.do {
      $0.snp.makeConstraints {
        $0.leading.equalToSuperview().inset(5)
        $0.size.equalTo(20)
        $0.centerY.equalToSuperview()
      }
    }
    
    deleteButton.do {
      $0.snp.makeConstraints {
        $0.size.equalTo(35)
        $0.trailing.equalToSuperview().inset(5)
        $0.centerY.equalToSuperview()
      }
    }
    
    contentLabel.do {
      $0.snp.makeConstraints{
        $0.leading.equalTo(searchImage.snp.trailing).offset(10)
        $0.trailing.equalTo(deleteButton.snp.leading).offset(10)
        $0.centerY.equalToSuperview()
      }
    }
  }
}
