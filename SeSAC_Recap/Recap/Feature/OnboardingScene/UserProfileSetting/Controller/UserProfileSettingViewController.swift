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
  
  let viewModel: UserProfileSettingViewModel = .init()
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureConfigurableMethods()
    viewModel.textValidationResult.bind { status in
      self.validationStatusLabel.do {
        $0.text = status.stateLabel
        $0.textColor = (status == .valid ? ColorStyle.pointColor : ColorStyle.warningColor )
      }
      self.doneButton.applyStyle(.primary, isEnabled: status == .valid)
    }
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
    viewModel.inputText.wrappedValue = textField.text
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
