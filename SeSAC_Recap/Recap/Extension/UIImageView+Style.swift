//
//  UIImageView+Style.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import UIKit

extension UIImageView {
  func setProfileStyle(){
    /// 프로필 이미지 둥글게 설정
    self.layer.cornerRadius = self.frame.width/2
    self.backgroundColor = ColorStyle.tintColor
    self.clipsToBounds = true
  }
  
  func setHighlight(isOn: Bool = true){
    /// border 굵게, 포인트 컬러 설정
    self.layer.borderWidth = isOn ? 3 : 0
    self.layer.borderColor = isOn ? ColorStyle.pointColor.cgColor : UIColor.clear.cgColor
  }
}
