//
//  NotificationManager.swift
//  SeSAC_Recap
//
//  Created by 쩡화니 on 1/28/24.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject {
  
  static let manager = NotificationManager()
  
  // NotificationManager는 Singleton 패턴으로 구현되어 하나의 인스턴스만 사용됩니다.
  private override init() {
    super.init()
    UNUserNotificationCenter.current().delegate = self // UNUserNotificationCenter의 delegate를 설정합니다.
  }
  
  /// 사용자에게 알림 권한을 요청하는 메서드
  func requestNotificationAuthorization() {
    
    /// 사용자에게 요청할 권한 옵션들
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { success, error in
      if success {
        UNUserNotificationCenter.current().getNotificationSettings {
          switch $0.authorizationStatus {
          case .authorized:
            print("authorized")
          case .denied:
            print("denied")
          case .ephemeral:
            print("ephemeral")
          case .notDetermined:
            print("notDetermined")
          case .provisional:
            print("provisional")
          @unknown default:
            print("unknown")
          }
        }
      } else {
        
      }
    }
  }
  
  func sendNotification(){
    
    /// request를 만드는 과정
    let content = UNMutableNotificationContent()
    content.title = "장바구니 확인해보셨나요?"
    content.body = "찜한 상품을 구매해보세요~!"
    
    var component = DateComponents()
    component.hour = 12
    component.minute = 30
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    /// * foreground 에 있을때는 노티가 안오는데 어케 하누?
    /// -> Foreground 에서는 알림이 뜨지 않는 것이 Default
    /// -> Foreground 에서 알림받고 싶으면, 프로토콜 구현해야함 (UNUserNotificationCenterDelegate)
    ///
    /// * 노티를 읽었을때 뱃지 카운트 업데이트 해줘야하는데, 어떻게 하누?
    UNUserNotificationCenter.current().add(request)
  }
  
  func removeAllNotifications(){
    /// 사용자에게 이미 전달되어 있는 노티들을 제거 (ex. 카톡)
    UNUserNotificationCenter.current()
      .removeAllDeliveredNotifications()
    
    /// 사용자에게 전달이 될 예정인 노티들을 제거
    UNUserNotificationCenter.current()
      .removeAllPendingNotificationRequests()
  }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
  
  /// 앱이 foreground 상태에서 알림을 받고자 할 경우 호출되는 메서드
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
    /// 알림이 배너 형태로 표시되도록 옵션을 설정
    completionHandler([.banner, .badge, .list, .sound])
  }
}
