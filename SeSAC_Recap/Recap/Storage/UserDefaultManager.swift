//
//  UserDefaultManager.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import Foundation

final class UserDefaultManager {
  
  private init() {}
  
  static var randomProfileImage: ProfileImage? {
    UserDefaultManager.profileImageList.randomElement()
  }
  
  @UserDefaultWrapper(key: Key.PROFILE_IAMGE.rawValue, defaultValue: ProfileImage.imageList)
  static var profileImageList: [ProfileImage]
  
  @UserDefaultWrapper(key: Key.PROFILE_INFO.rawValue, defaultValue: ProfileInfo(profileImage: UserDefaultManager.randomProfileImage))
  static var profileInfo: ProfileInfo
  
  /// 1) Dictionary 로 선언하고, 검색 내용을 Key로 두고 가져오는 방법
  /// 2) 리스트로 선언하고, append, clear, .. 하는 방법....
  /// 어떤게 좋을까?
  @UserDefaultWrapper(key: Key.SEARCH_HISTORY.rawValue, defaultValue: [])
  static var searchHistoryLog: [SearchHistory]
  
  @UserDefaultWrapper(key: Key.FAVORITE_PRODUCT.rawValue, defaultValue: [Product.ID: Product]())
  static var favoriteProductDict: [Product.ID: Product]
  
  static func resetAllLocalData(){
    /// 데이터 초기화
    UserDefaultManager.profileInfo.nickName = .init()
    UserDefaultManager.profileInfo.profileImage = UserDefaultManager.randomProfileImage
    UserDefaultManager.favoriteProductDict = .init()
    UserDefaultManager.searchHistoryLog = .init()
  }
  
  static func updateFavoriteProducts(product: Product){
    /// 좋아요인 경우
    if product.isLiked {
      favoriteProductDict[product.id] = product
    } else {
      favoriteProductDict.removeValue(forKey: product.id)
    }
  }
}

extension UserDefaultManager {
  /// 키 정의
  enum Key: String {
    case PROFILE_IAMGE
    case PROFILE_INFO
    case SEARCH_HISTORY
    case FAVORITE_PRODUCT
  }
}
