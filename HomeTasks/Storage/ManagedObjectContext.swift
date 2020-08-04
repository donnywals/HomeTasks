//
//  ManagedObjectContext.swift
//  HomeTasks
//
//  Created by Donny Wals on 16/07/2020.
//

import CoreData

extension NSManagedObjectContext {
  func saveOrRollback() {
    guard hasChanges else {
      return
    }
    
    do {
      try save()
    } catch {
      rollback()
      print(error)
    }
  }
}
