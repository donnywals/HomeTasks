//
//  NotificationHandler.swift
//  HomeTasks
//
//  Created by Donny Wals on 02/07/2020.
//

import UIKit
import UserNotifications
import Combine

class NotificationHandler: NSObject, ObservableObject {
  let notificationCenter = UNUserNotificationCenter.current()
  
  var cancellables = Set<AnyCancellable>()
  
  override init() {
    super.init()

    notificationCenter.delegate = self
  }
  
  func addDummyNotification() {
    notificationCenter
      .authorizationStatusByRequesting(options: [.alert, .badge, .sound])
      .flatMap({ [unowned self] status -> UNUserNotificationCenter.NotificationRequestedPublisher in
        guard status == .authorized || status == .provisional else {
          return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Test notification"
        content.body = "This is a test notification"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2,
                                                        repeats: false)
        
        let request = UNNotificationRequest(identifier: "com.donnywals.notifications.\(UUID())",
                                            content: content, trigger: trigger)
        
        return self.notificationCenter.add(request)
      })
      .sink(receiveCompletion: { completion in
        if case .finished = completion {
          print("Scheduled notification")
        } else if case .failure(let error) = completion {
          print("Something went wrong: \(error)")
        }
      }, receiveValue: { _ in })
      .store(in: &cancellables)
  }
}

extension NotificationHandler: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              openSettingsFor notification: UNNotification?) {
    // no-op
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    
    // user responded to notification
    print("handle response")
    let url = URL(string: "hometasks://task/F7BEE432-F57A-479F-B83C-E5E1AD7DB527")!
    UIApplication.shared.open(url, options: [:]) { bool in
      print(bool)
    }
    completionHandler()
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // received notification
    print("handle receiving")
    completionHandler([.badge, .banner, .sound])
  }
}
