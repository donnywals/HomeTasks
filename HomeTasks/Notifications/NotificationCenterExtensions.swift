//
//  NotificationCenterExtensions.swift
//  HomeTasks
//
//  Created by Donny Wals on 05/07/2020.
//

import UserNotifications
import Combine

extension UNUserNotificationCenter {
  typealias AuthorizationStatusPublisher = AnyPublisher<UNAuthorizationStatus, Never>
  typealias AuthorizationRequestPublisher = AnyPublisher<Bool, Error>
  typealias NotificationRequestedPublisher = AnyPublisher<Void, Error>
  
  func currentAuthorizationStatus() -> AuthorizationStatusPublisher {
    return Future { [unowned self] promise in
      self.getNotificationSettings { settings in
        promise(.success(settings.authorizationStatus))
      }
    }.eraseToAnyPublisher()
  }
  
  func requestAuthorization(options: UNAuthorizationOptions) -> AuthorizationRequestPublisher {
    return Future { [unowned self] promise in
      self.requestAuthorization(options: options) { success, error in
        if let error = error {
          promise(.failure(error))
          return
        }
        
        promise(.success(success))
      }
    }.eraseToAnyPublisher()
  }
  
  func authorizationStatusByRequesting(options: UNAuthorizationOptions) -> AuthorizationStatusPublisher {
    return currentAuthorizationStatus()
      .flatMap({ [unowned self] status -> AuthorizationStatusPublisher in
        if status == .notDetermined {
          return self.requestAuthorization(options: options)
            .replaceError(with: false)
            .flatMap({ result -> AuthorizationStatusPublisher in
              return currentAuthorizationStatus()
            })
            .eraseToAnyPublisher()
        } else {
          return Just(status)
            .eraseToAnyPublisher()
        }
      }).eraseToAnyPublisher()
  }
  
  func add(_ request: UNNotificationRequest) -> NotificationRequestedPublisher {
    return Future { [unowned self] promise in
      self.add(request) { error in
        if let error = error {
          promise(.failure(error))
          return
        }
        
        promise(.success(()))
      }
    }.eraseToAnyPublisher()
  }
}
