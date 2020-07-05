//
//  AppURLs.swift
//  HomeTasks
//
//  Created by Donny Wals on 05/07/2020.
//

import Foundation

extension URL {
  var isDeeplink: Bool {
    return self.scheme == "hometasks"
  }
  
  var appSection: AppSection? {
    guard isDeeplink else {
      return nil
    }

    if host == "tasklist" {
      return .tasksOverview
    } else if host == "task" {
      guard pathComponents.count > 1,
            let id = UUID(uuidString:pathComponents[1]) else {
        
        return nil
      }
      
      return .task(id: id)
    } else if host == "settings" {
      return .settings
    }
    
    return nil
  }
}

extension URL {
  enum AppSection: Equatable {
    case tasksOverview
    case settings
    case task(id: UUID)
  }
}
