//
//  SearchService.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import Alamofire
import Foundation

class SearchService {
  
  static let shared = SearchService()
  
  private init() {}
  
  func callRequest(request: NaverShopSearchEntity.Request, completion: @escaping (Result<NaverShopSearchEntity.Response, NetworkError>) -> Void){
    
    let baseURL = "https://openapi.naver.com/v1/search/shop.json"
    
    // Request 객체를 사용하여 파라미터 구성
    let parameters: [String: Any] = [
      "query": request.query,
      "display": request.display,
      "start": request.start,
      "sort": request.sort.rawValue // SortType을 rawValue로 변환하여 전달
    ]
    
    let headers: HTTPHeaders = [
      "X-Naver-Client-Id": AppConfiguration.shared.naverClientID,
      "X-Naver-Client-Secret": AppConfiguration.shared.naverClientSecret
    ]
    
    if let url = try? URLRequest(url: baseURL, method: .get, headers: nil).asURLRequest().url?.absoluteString {
      print("Request URL: \(url)") // URL을 출력
    }
    
    AF.request(baseURL, method: .get, parameters: parameters, headers: headers)
      .responseDecodable(of: NaverShopSearchEntity.Response.self) { res in
        switch res.result {
        case .success(let success):
          completion(.success(success))
        case .failure(let error):
          dump(error)
          guard let data = res.data, let response = res.response else {
            print(res.data)
            completion(.failure(.unknown("알 수 없는 에러")))
            return
          }
          completion(.failure(NetworkError.checkError(data: data, response: response) ?? .unknown("알 수 없는 에러")))
        }
      }
  }
}
