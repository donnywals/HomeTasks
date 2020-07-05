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
      return .taskList
    } else if host == "task" {
      guard pathComponents.count > 1,
            let id = UUID(uuidString:pathComponents[1]) else {
        
        return nil
      }
      
      return .task(id: id)
    }
    
    return nil
  }
}

extension URL {
  enum AppSection {
    case taskList
    case task(id: UUID)
  }
}
