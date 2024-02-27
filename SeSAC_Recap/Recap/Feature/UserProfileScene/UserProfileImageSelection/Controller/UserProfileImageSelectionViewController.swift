//
//  UserProfileImageSelectionViewController.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/21/24.
//

import UIKit

class UserProfileImageSelectionViewController: UIViewController {
  
  @IBOutlet weak var selectedImageView: UIImageView!
  @IBOutlet weak var profileCollectionView: UICollectionView!
  
  var dataSource = [Section]()
  
  var profileInfo: ProfileInfo {
    get {
      UserDefaultManager.profileInfo
    }
    set {
      UserDefaultManager.profileInfo = newValue
    }
  }
  
  var profileImageList: [ProfileImage] {
    UserDefaultManager.profileImageList
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureConfigurableMethods()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
}

extension UserProfileImageSelectionViewController: UIViewControllerConfigurable {
  
  func updateImageView(){
    selectedImageView.image = profileInfo.profileImage?.image
  }
  
  func configureView() {
    setDefaultBackground()
  }
  
  func configureNavigationBar() {
    navigationItem.title = "프로필 설정"
  }
  
  func configureImageView() {
    selectedImageView.setProfileStyle()
    selectedImageView.setHighlight(isOn: true)
  }
  
  func configureCollectionView() {
    profileCollectionView.delegate = self
    profileCollectionView.dataSource = self
    profileCollectionView.showsVerticalScrollIndicator = false
    profileCollectionView.register(UINib(nibName: ProfileImageCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProfileImageCell.identifier)
    
    /// 레이아웃 설정
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 5 /// 셀 간 가로길이
    layout.minimumLineSpacing = 10 /// 셀 간 세로 길이
    profileCollectionView.collectionViewLayout = layout
    
    /// 데이터 리프레시
    refresh()
  }
  
  private func refresh() {
    var profileModels: [ProfileModel] {
      profileImageList.map {
        .init(profileImage: $0, isSelected: $0.id == profileInfo.profileImage?.id)
      }
    }
    let profileSection = Section.profile(profileModels)
    self.dataSource = [profileSection]
    self.profileCollectionView.reloadData()
    updateImageView()
  }
}

extension UserProfileImageSelectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch self.dataSource[indexPath.section] {
    case .profile(let profileModels):
      profileInfo.profileImage = profileModels[indexPath.item].profileImage
      refresh()
    }
  }
}

extension UserProfileImageSelectionViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch self.dataSource[section] {
    case let .profile(profileModels):
      profileModels.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch self.dataSource[indexPath.section] {
    case let .profile(profileModels):
      let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCell.identifier, for: indexPath) as! ProfileImageCell
      let profileModel = profileModels[indexPath.item]
      cell.prepare(profileImage: profileModel.profileImage.image, isSelected: profileModel.isSelected)
      return cell
    }
  }
}

extension UserProfileImageSelectionViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    let numberOfItemsInRow: Int = 4
    let itemSpacing = layout.minimumInteritemSpacing
    let sectionInset = layout.sectionInset
    let totalSpacing = (itemSpacing * CGFloat(numberOfItemsInRow - 1)) + sectionInset.left + sectionInset.right
    
    let availableWidth = collectionView.frame.width - totalSpacing
    let itemWidth = availableWidth / CGFloat(numberOfItemsInRow)
    
    return CGSize(width: itemWidth, height: itemWidth)
  }
}

extension UserProfileImageSelectionViewController {
  enum Section {
    case profile([ProfileModel])
  }
  
  struct ProfileModel {
    let profileImage: ProfileImage
    let isSelected: Bool
  }
}
