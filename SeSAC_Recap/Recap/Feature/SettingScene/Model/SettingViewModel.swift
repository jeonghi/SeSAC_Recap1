//
//  SettingViewModel.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 2/23/24.
//

//import Foundation
import UIKit

class SettingViewModel {
  var dataSource: Observable<[SettingSection]> = .init([])
  
  var numberOfSections: Int {
    self.dataSource.wrappedValue.count
  }  
}

extension SettingViewModel {
  
  func refresh() {
    // 프로필
    let profileModel = ProfileModel(
      profileImage: UserDefaultManager.profileInfo.profileImage?.image,
      titleText: UserDefaultManager.profileInfo.nickName,
      descriptionText: "\(UserDefaultManager.favoriteProductDict.count)개의 상품을 좋아하고 있어요"
    )
    let profileSection = SettingSection.profile([profileModel])
    
    /// 타이틀
    let titleModels: [TitleModel] = ["공지사항", "자주 묻는 질문", "1:1 문의", "알림설정", "처음부터 시작하기"].map{
      TitleModel.init(title: $0)
    }
    let titleSection = SettingSection.title(titleModels)
    
    self.dataSource.wrappedValue = [profileSection, titleSection]
  }
  
  func numberOfRowsInSection(for section: Int) -> Int {
    switch self.dataSource.wrappedValue[section] {
    case let .profile(profileModels):
      profileModels.count
    case let .title(titleModels):
      titleModels.count
    }
  }
  
  func tableViewHeightForRowAt(for indexPath: IndexPath) -> CGFloat {
    switch dataSource.wrappedValue[indexPath.section] {
    case .profile:
      return 80
    case .title:
      return 40
    }
  }
}

extension SettingViewModel {
  enum SettingSection {
    case profile([ProfileModel])
    case title([TitleModel])
  }
  
  struct ProfileModel {
    let profileImage: UIImage? // 나중에 분리하기 ⭐️
    let titleText: String?
    let descriptionText: String?
  }
  
  struct TitleModel: Equatable {
    let title: String?
  }
}
