//
//  HTTPHeaderField.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 2/6/24.
//

import Foundation

enum HTTPHeaderField: String {
  case authentication = "Authorization"
  case contentType = "Content-Type"
  case acceptType = "Accept"
}

enum ContentType: String {
  case json = "Application/json"
}

enum AuthenticationType: String {
  case bearer = "Bearer"
  case basic = "Basic"
}
