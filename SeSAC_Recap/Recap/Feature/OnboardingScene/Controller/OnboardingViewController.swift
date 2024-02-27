//
//  OnboardingViewController.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/19/24.
//

import UIKit
import Then
import Toast

class OnboardingViewController: UIViewController {
  
  // MARK: Property
  @IBOutlet weak var startButton: UIButton!
  
  // MARK: Life cycle
  override func viewDidLoad(){
    configureConfigurableMethods()
    DispatchQueue.main.async {
      self.view.makeToast("안녕하세요", duration: 2 ,position: .top)
    }
  }
  
  // MARK: Method
  @objc func tappedStartButton(_ sender: UIButton){
    /// 스토리보드에서 프로필 설정화면을 불러옵니다.
    let identifier = UserProfileSettingViewController.identifier
    let sb = UIStoryboard(name: identifier, bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: identifier)
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

extension OnboardingViewController: UIViewControllerConfigurable {
  
  func configureView() {
    setDefaultBackground()
  }
  
  func configureButton() {
    startButton = startButton.then {
      $0.setTitle("시작하기", for: .normal)
      $0.applyStyle(.primary, isEnabled: true)
      $0.addTarget(self, action: #selector(tappedStartButton), for: .touchUpInside)
    }
  }
}
