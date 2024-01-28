//
//  NetworkManager.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/26/24.
//

import Foundation
import Network

class NetworkManager {
  static let shared = NetworkManager()
  
  private let monitor = NWPathMonitor()
  
  private init() {
    monitor.pathUpdateHandler = { path in
      if path.status == .satisfied {
        // 네트워크 연결이 좋음
        print("네트워크 연결이 좋음")
      } else {
        // 네트워크 연결이 좋지 않음
        print("네트워크 연결이 좋지 않음")
        NotificationCenter.default.post(name: Notification.Name("NetworkStatusChanged"), object: nil)
      }
    }
    
    let queue = DispatchQueue(label: "NetworkMonitor")
    monitor.start(queue: queue)
  }
}
