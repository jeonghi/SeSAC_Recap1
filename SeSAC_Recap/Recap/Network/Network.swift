//
//  Network.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 2/6/24.
//

import Foundation
import Alamofire

struct Network<T: TargetType> {}

extension Network {
 
  func request<R>(_ target: T, responseType: R.Type, completion: @escaping ((Result<R?, NetworkError>) -> Void)) where T: TargetType, R: Decodable {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    guard let urlRequest = try? target.asURLRequest() else {
      /// 에러 타입을 새로 정의해야하나?
      return
    }
    
    #if(DEBUG)
//    dump(urlRequest.url)
    #endif
    
    AF.request(urlRequest, interceptor: nil)
      .responseDecodable(of: R.self) { res in
        switch res.result {
        case .success(let success):
          completion(.success(success))
        case .failure(let error):
          #if(DEBUG)
//          dump(error)
          #endif
          guard let data = res.data, let response = res.response else {
            completion(.failure(.unknown("알 수 없는 에러")))
            return
          }
          completion(.failure(NetworkError.checkError(data: data, response: response) ?? .unknown("알 수 없는 에러")))
        }
      }
  }
  
  func requestUrlSession<R>(_ target: T, responseType: R.Type, completion: @escaping ((Result<R?, NetworkError>) -> Void)) where T: TargetType, R: Decodable {
    let decoder = JSONDecoder()
    
    decoder.dateDecodingStrategy = .iso8601
    
    guard let urlRequest = try? target.asURLRequest() else {
      return
    }
    
    let task = URLSession.shared.dataTask(with: urlRequest) { data, res, error in
      DispatchQueue.main.async {
        
        if let error {
          completion(.failure(.unknown("알 수 없는 에러")))
          return
        }
        
        guard let data else {
          completion(.failure(.unknown("알 수 없는 에러")))
          return
        }
        
        do {
          let result = try JSONDecoder().decode(R.self, from: data)
          completion(.success(result))
        } catch {
          completion(.failure(.unknown("알 수 없는 에러")))
        }
      }
    }
    
    task.resume()
  }
}
