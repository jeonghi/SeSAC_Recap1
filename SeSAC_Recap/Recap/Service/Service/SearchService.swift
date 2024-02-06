//
//  SearchService.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import Alamofire
import Foundation

typealias ProductResponse = NaverShopSearchEntity.Response
typealias ProductResponseHandler = (Result<ProductResponse?, NetworkError>) -> Void

protocol NaverShopingServiceType {
  func searchProduct(request: NaverShopSearchEntity.Request, completion: @escaping ProductResponseHandler)
}

class NaverShopingService {
  
  static let shared = NaverShopingService()
  
  private let network = Network<NaverAPI>()
  
  private init() {}
  
  func searchProduct(request: NaverShopSearchEntity.Request, completion: @escaping ProductResponseHandler){
    
    network.requestUrlSession(.getProductList(query: request.query, display: request.display, start: request.start, sort: request.sort.rawValue), responseType: ProductResponse.self, completion: completion)
  }
}
