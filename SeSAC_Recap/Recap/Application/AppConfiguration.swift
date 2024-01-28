//
//  AppConfiguration.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import Foundation

final class AppConfiguration {
  
  static let shared = AppConfiguration()
  private init(){}
  
  lazy var naverClientID: String = {
    guard let naverClientID = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_ID") as? String else {
      fatalError("네이버 클라이언트 ID must not be empty in plist")
    }
    return naverClientID
  }()
  
  lazy var naverClientSecret: String = {
    guard let naverClientSecret = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_SECRET") as? String else {
      fatalError("네이버 클라이언트 시크릿 must not be empty in plist")
    }
    return naverClientSecret
  }()
}
