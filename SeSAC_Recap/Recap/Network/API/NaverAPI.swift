//
//  NaverAPI.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 2/6/24.
//

import Foundation
import Alamofire

enum NaverAPI {
  case getProductList(query: String, display: Int, start: Int, sort: String)
}

extension NaverAPI: TargetType {
  var baseURL: String {
    "https://openapi.naver.com/v1"
  }
  
  var method: HTTPMethod {
    .get
  }
  
  var path: String {
    "/search/shop.json"
  }
  
  var params: RequestParams {
    switch self {
    case let .getProductList(query, display, start, sort):
      
      return .query([
        "query": query,
        "display": "\(display)",
        "start": "\(start)",
        "sort": sort
      ])
    }
  }
  
  var headers: HTTPHeaders {
    [
      "X-Naver-Client-Id": AppConfiguration.shared.naverClientID ,
      "X-Naver-Client-Secret": AppConfiguration.shared.naverClientSecret
    ]
  }
}
