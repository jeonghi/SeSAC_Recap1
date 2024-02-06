//
//  RequestParams.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 2/6/24.
//

import Foundation

enum RequestParams {
  case query(_ param: Encodable?)
  case body(_ param: Encodable?)
  case none
}
