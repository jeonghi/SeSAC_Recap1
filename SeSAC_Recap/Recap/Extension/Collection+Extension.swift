//
//  Collection+Extension.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/27/24.
//

import Foundation

extension Collection {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
