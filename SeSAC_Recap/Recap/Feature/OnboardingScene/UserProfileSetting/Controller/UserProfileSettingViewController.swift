//
//  UserProfileSettingViewController.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit
import Then

class UserProfileSettingViewController: UIViewController {
  
  // MARK: Property
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nicknameTextField: UITextField!
  @IBOutlet weak var validationStatusLabel: UILabel!
  @IBOutlet weak var doneButton: UIButton!
  
  let viewModel: UserProfileSetttingViewModel = .init()
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureConfigurableMethods()
    updateValidationStatus(nicknameTextField.text)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  // MARK: Method
  @objc func textFieldDidChange(_ textField: UITextField) {
    updateValidationStatus(textField.text)
  }
  
  @IBAction func tappedAroundView(_ sender: Any) {
    self.view.endEditing(true)
  }
  
  @IBAction func tappedProfileImage(_ sender: UIButton) {
    let identifier = UserProfileImageSelectionViewController.identifier
    let sb = UIStoryboard(name: identifier, bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: identifier)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func tappedDoneButton(_ sender: UIButton) {
    
    /// 프로필 정보 저장
    viewModel.profileInfo.nickName = nicknameTextField.text
    
    /// 현재 내비게이션 스택의 루트 뷰 컨트롤러 확인
    if let rootViewController = navigationController?.viewControllers.first {
      if(rootViewController is OnboardingViewController){
        replaceRootMainTab()
      } else {
        backToSetting()
      }
    }
  }
  
  func replaceRootMainTab(){
    let identifier = MainTabBarViewController.identifier
    let sb = UIStoryboard(name: identifier, bundle: nil)
    let mainTabViewController = sb.instantiateViewController(withIdentifier: identifier)
    
    if #available(iOS 14.0, *){
      view.window?.rootViewController = mainTabViewController
    } else {
      if let window = UIApplication.shared.windows.first {
        window.rootViewController = mainTabViewController
      }
    }
  }
  
  func backToSetting(){
    navigationController?.popViewController(animated: true)
  }
}

// MARK: View defined
extension UserProfileSettingViewController {
  
  /// 텍스트 필드 검증 타입
//  enum ValidationState {
//    case valid
//    case invalidLength
//    case invalidSpecialCharacter(character: Character)
//    case invalidNumberCharacter(character: Character)
//    
//    var stateLabel: String {
//      switch self {
//      case .valid:
//        return "사용할 수 있는 닉네임이에요"
//      case .invalidLength:
//        return "2글자 이상 10글자 미만으로 설정해주세요"
//      case .invalidSpecialCharacter(let character):
//        return "닉네임에 특수 문자 '\(character)'는 포함할 수 없어요"
//      case .invalidNumberCharacter(let character):
//        return "닉네임에 숫자 '\(character)'는 포함할 수 없어요"
//      }
//    }
//    
//    var stateColor: UIColor {
//      switch self {
//      case .valid:
//        return ColorStyle.pointColor
//      default:
//        return ColorStyle.warningColor
//      }
//    }
//  }
  
  // 흠냐흠냐.. 단점?, 에러 타입별로 색상을 달리하려면 Error 바깥 Scope에서 관리해야한다는 점.
  // valid에 대한 상태관리는 별도로 가지고 있지 않다는점..
  enum ValidationError: Error, LocalizedError {
    case invalidLength
    case invalidSpecialCharacter(character: Character)
    case invalidNumberCharacter(character: Character)
    
    public var errorDescription: String? {
      switch self {
      case .invalidLength:
        return "2글자 이상 10글자 미만으로 설정해주세요"
      case .invalidSpecialCharacter(let character):
        return "닉네임에 특수 문자 '\(character)'는 포함할 수 없어요"
      case .invalidNumberCharacter(let character):
        return "닉네임에 숫자 '\(character)'는 포함할 수 없어요"
      }
    }
  }
  
  /// 텍스트 필드 검증 로직
  func validateText(_ text: String?) throws -> Void {
    
    guard let text else { throw ValidationError.invalidLength }
    
    /// 길이 검사
    if text.count < 2 || text.count >= 10 { throw ValidationError.invalidLength }
    
    /// 특수 문자 및 숫자 검사 (정규표현식 사용)
    let specialCharacterRegex = ".*[@#$%].*"
    let numberRegex = ".*[0-9].*"
    
    if let _ = text.range(of: specialCharacterRegex, options: .regularExpression) {
      /// 특수 문자가 발견된 경우
      if let invalidCharacter = text.first(where: { "@#$%".contains($0) }) {
        throw ValidationError.invalidSpecialCharacter(character: invalidCharacter)
      }
    }
    
    if let _ = text.range(of: numberRegex, options: .regularExpression) {
      /// 숫자가 발견된 경우
      if let invalidCharacter = text.first(where: { "0123456789".contains($0) }) {
        throw ValidationError.invalidNumberCharacter(character: invalidCharacter)
      }
    }
  }
  
  func updateValidationStatus(_ text: String?) {
    do {
      try validateText(text)
      validationStatusLabel.text = "사용할 수 있는 닉네임이에요"
      validationStatusLabel.textColor = ColorStyle.pointColor
      doneButton.applyStyle(.primary, isEnabled: true)
    } catch {
      if let error = error as? ValidationError {
        validationStatusLabel.text = error.localizedDescription
      } else {
        validationStatusLabel.text = "알 수 없는 문제가 발생했습니다."
      }
      validationStatusLabel.textColor = ColorStyle.warningColor
      doneButton.applyStyle(.primary, isEnabled: false)
    }
  }
}


// MARK: 기본 설정
extension UserProfileSettingViewController: UIViewControllerConfigurable {
  
  func updateView(){
    profileImageView.image = viewModel.profileInfo.profileImage?.image
  }
  
  func configureView() {
    setDefaultBackground()
  }
  
  func configureImageView() {
    profileImageView.do {
      $0.setProfileStyle()
      $0.setHighlight(isOn: true)
    }
  }
  
  func configureNavigationBar() {
    navigationItem.title = "프로필 설정"
  }
  
  func configureButton() {
    doneButton.do {
      $0.setTitle("완료", for: .normal)
    }
  }
  
  func configureTextField() {
    nicknameTextField.do {
      $0.delegate = self
      $0.placeholder = "닉네임을 입력해주세요 :)"
      $0.textColor = ColorStyle.unpointColor
      $0.font = FontStyle.systemFont17
      $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
      $0.addBottomLineToTextField()
      $0.text = viewModel.profileInfo.nickName
    }
  }
  
  func configureLabel() {
    validationStatusLabel.do {
      $0.font = FontStyle.systemFont13
    }
  }
}

extension UserProfileSettingViewController: UITextFieldDelegate {
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return true
  }
}
