//
//  UserProfileSetttingViewModel.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 2/22/24.
//

import Foundation
//import UIKit

class UserProfileSettingViewModel {
  
  var profileInfo: ProfileInfo {
    get { UserDefaultManager.profileInfo }
    set { UserDefaultManager.profileInfo = newValue }
  }
  
  @Observable var inputText: String? = ""
  @Observable var textValidationResult: ValidationState = .invalidLength
  
  init() {
    inputText = self.profileInfo.nickName
    _inputText.bind {
      self.textValidationResult = self.validateText($0)
    }
  }
  
  func bindValidationResult(_ closure: ((ValidationState) -> Void)?) {
      _textValidationResult.bind(closure)
  }
}

extension UserProfileSettingViewModel {

  func validateText(_ text: String?) -> ValidationState {

      guard let text else {
        return .invalidLength
      }
      
      /// 길이 검사
      if text.count < 2 || text.count >= 10 {
        return .invalidLength
      }
      
      /// 특수 문자 및 숫자 검사 (정규표현식 사용)
      let specialCharacterRegex = ".*[@#$%].*"
      let numberRegex = ".*[0-9].*"
      
      if let _ = text.range(of: specialCharacterRegex, options: .regularExpression) {
        /// 특수 문자가 발견된 경우
        if let invalidCharacter = text.first(where: { "@#$%".contains($0) }) {
          return .invalidSpecialCharacter(character: invalidCharacter)
        }
      }
      
      if let _ = text.range(of: numberRegex, options: .regularExpression) {
        /// 숫자가 발견된 경우
        if let invalidCharacter = text.first(where: { "0123456789".contains($0) }) {
          return .invalidNumberCharacter(character: invalidCharacter)
        }
      }
      
      return .valid
    
  }
}

extension UserProfileSettingViewModel {
  /// 텍스트 필드 검증 타입
  enum ValidationState: Equatable {
    case valid
    case invalidLength
    case invalidSpecialCharacter(character: Character)
    case invalidNumberCharacter(character: Character)

    var stateLabel: String {
      switch self {
      case .valid:
        return "사용할 수 있는 닉네임이에요"
      case .invalidLength:
        return "2글자 이상 10글자 미만으로 설정해주세요"
      case .invalidSpecialCharacter(let character):
        return "닉네임에 특수 문자 '\(character)'는 포함할 수 없어요"
      case .invalidNumberCharacter(let character):
        return "닉네임에 숫자 '\(character)'는 포함할 수 없어요"
      }
    }
  }
}
