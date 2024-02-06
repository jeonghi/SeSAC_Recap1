//
//  TargetType.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 2/6/24.
//

import Alamofire
import Foundation

protocol TargetType: URLRequestConvertible {
  var baseURL: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var params: RequestParams { get }
  var headers: HTTPHeaders { get }
}

extension TargetType {
  func asURLRequest() throws -> URLRequest {
    let url = try baseURL.asURL()
    var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
    
    urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
    
    headers.dictionary.keys.forEach {
      urlRequest.setValue(headers[$0], forHTTPHeaderField: $0)
    }
    
    switch params {
    case .query(let request):
      let params = request?.toDictionary() ?? [:]
      let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
      var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
      components?.queryItems = queryParams
      urlRequest.url = components?.url
    case .body(let request):
      let params = request?.toDictionary() ?? [:]
      urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
    case .none:
      break
    }
    
    return urlRequest
  }
}
