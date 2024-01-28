//
//  SearchHistory.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/22/24.
//

import Foundation

struct SearchHistory: Codable {
  let searchTerm: String
  let searchDate: Date
  
  init(searchTerm: String, searchDate: Date = Date()) {
    self.searchTerm = searchTerm
    self.searchDate = searchDate
  }
}
