//
//  Encodable+toDictionary.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 2/6/24.
//

import Foundation

extension Encodable {
  func toDictionary() -> [String: Any] {
    guard let data = try? JSONEncoder().encode(self),
          let jsonData = try? JSONSerialization.jsonObject(with: data),
          let dictionaryData = jsonData as? [String: Any] else { return [:] }
    return dictionaryData
  }
}
