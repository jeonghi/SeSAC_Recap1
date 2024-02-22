//
//  UserProfileSetttingViewModel.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 2/22/24.
//

import Foundation

class UserProfileSetttingViewModel {
  
  var profileInfo: ProfileInfo {
    get {
      UserDefaultManager.profileInfo
    }
    set {
      UserDefaultManager.profileInfo = newValue
    }
  }
  
  @Observable var inputText: String = ""
  @Observable var outputText: String = ""
  
  func bindOutputResult(_ closure: @escaping (String) -> Void) {
      _outputText.bind(closure)
  }
}

extension UserProfileSetttingViewModel {

}
