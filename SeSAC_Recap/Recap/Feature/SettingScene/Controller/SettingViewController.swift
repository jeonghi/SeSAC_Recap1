//
//  SettingViewController.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit
import Then
import Toast

class SettingViewController: UIViewController {
  
  @IBOutlet weak var settingTableView: UITableView!
  
  let viewModel = SettingViewModel()
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureConfigurableMethods()
    refresh()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    refresh()
  }
  
  private func refresh() {
    viewModel.dataSource.bind { _ in
      self.settingTableView.reloadData()
    }
  }
}

extension SettingViewController: UIViewControllerConfigurable {
  
  func configureView() {
    setDefaultBackground()
  }
  
  func configureNavigationBar() {
    self.navigationItem.title = "설정"
  }
  
  func configureTableView() {
    
    settingTableView = settingTableView.then {
      $0.delegate = self
    }
    
    settingTableView.delegate = self
    settingTableView.dataSource = self
    
    settingTableView.backgroundColor = .clear
    settingTableView.separatorColor = ColorStyle.tintColor
    
    settingTableView.register(UINib(nibName: ProfileCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileCell.identifier)
    settingTableView.register(UINib(nibName: TitleCell.identifier, bundle: nil), forCellReuseIdentifier: TitleCell.identifier)
  }
}

extension SettingViewController {
  /// "처음부터 시작하기" 셀을 선택했을 때 실행될 메서드, 얼럿을 띄움.
  private func alertRestart() {
    
    let alertController = UIAlertController(
      title: "처음부터 시작하기",
      message: "데이터를 모두 초기화하시겠습니까?",
      preferredStyle: .alert
    )
    
    let cancelAction = UIAlertAction(
      title: "취소",
      style: .cancel,
      handler: nil
    )
    
    let confirmAction = UIAlertAction(
      title: "확인",
      style: .default
    ) { _ in
      self.confirmRestart()
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(confirmAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
  /// 초기화 승인 메서드, 얼럿과 연결
  private func confirmRestart() {
    
    let identifier = OnboardingViewController.identifier
    
    let sb = UIStoryboard(name: identifier, bundle: nil)
    
    /// 온보딩 화면으로 전환
    let onboardingVC = sb.instantiateViewController(withIdentifier: identifier)
    
    let navVC = UINavigationController(rootViewController: onboardingVC)
    
    /// os 버전에 따라 다르게 분기
    if #available(iOS 14.0, *){
      view.window?.rootViewController = navVC
    } else {
      if let window = UIApplication.shared.windows.first {
        window.rootViewController = navVC
      }
    }
    
    DispatchQueue.global().async {
      UserDefaultManager.resetAllLocalData()
    }
  }
}

// MARK: 테이블 뷰 델리게이트 (액션 처리)
extension SettingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch self.viewModel.dataSource.wrappedValue[indexPath.section] {
    case .profile:
      let identifier = UserProfileSettingViewController.identifier
      let sb = UIStoryboard(name: identifier, bundle: nil)
      let vc = sb.instantiateViewController(withIdentifier: identifier)
      navigationController?.pushViewController(vc, animated: true)
      
      return
    case .title(let titleModels):
      if(titleModels[indexPath.row] == titleModels.last){
        alertRestart()
      }
      return
    }
  }
}

// MARK: 테이블 뷰 데이터소스 (레이아웃 설정)
extension SettingViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    self.viewModel.numberOfSections
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.viewModel.numberOfRowsInSection(for: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch self.viewModel.dataSource.wrappedValue[indexPath.section] {
    case let .profile(profileModels):
      let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
      let profileModel = profileModels[indexPath.row]
      cell.prepare(profileImage: profileModel.profileImage, titleText: profileModel.titleText, supplementText: profileModel.descriptionText)
      cell.selectionStyle = .none
      return cell
    case let .title(titleModels):
      let cell = tableView.dequeueReusableCell(withIdentifier: TitleCell.identifier, for: indexPath) as! TitleCell
      let titleModel = titleModels[indexPath.row]
      cell.prepare(titleText: titleModel.title)
      cell.selectionStyle = .none
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    viewModel.tableViewHeightForRowAt(for: indexPath)
  }
}
