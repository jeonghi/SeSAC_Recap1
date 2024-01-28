//
//  NaverShopSearchEntity.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import Foundation

enum NaverShopSearchEntity {
  
  struct Request: Codable {
    
    let query: String /// 검색 문자
    let display: Int /// 30을 기본으로 가져오도록 함.
    let start: Int
    let sort: SortType
    
    init(query: String, display: Int = 30, start: Int = 0, sort: SortType = .sim) {
      self.query = query
      self.display = display
      self.start = start
      self.sort = sort
    }
    
    var parameters: [String: Any] {
      return [
        "query": query,
        "display": display,
        "start": start,
      ]
    }
    
    enum SortType: String, Codable, CaseIterable {
      
      case sim /// 정확도순으로 내림차순 정렬 (기본값)
      case date /// 날짜순으로 내림차순 정렬
      case asc /// 가격순으로 오름차순 정렬
      case dsc /// 가격순으로 내림차순 정렬
      
      var label: String {
        switch self {
        case .sim:
          return "정확도"
        case .date:
          return "날짜순"
        case .asc:
          return "가격낮은순"
        case .dsc:
          return "가격높은순"
        }
      }
    }
  }
  
  struct Response: Codable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [ShopItem]
  }
  
  struct ShopItem: Codable {
    let title: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
  }
}
