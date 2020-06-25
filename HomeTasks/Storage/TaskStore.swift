//
//  TasksStore.swift
//  HomeTasks
//
//  Created by Donny Wals on 24/06/2020.
//

import Foundation
import CoreData
import SwiftUI

class TaskStore: ObservableObject {
  @Published var tasks: [ManagedTask]
  
  let persistentContainer: NSPersistentContainer
  
  init(persistentContainer: NSPersistentContainer) {
    self.persistentContainer = persistentContainer
    
    let request: NSFetchRequest<ManagedTask> = ManagedTask.fetchRequest()
    tasks = try! persistentContainer.viewContext.fetch(request)
  }
  
  func addTask(withName name: String) {
    let task = ManagedTask(context: persistentContainer.viewContext)
    task.id = UUID()
    task.name = name
    
    try? persistentContainer.viewContext.save()
    
    let request: NSFetchRequest<ManagedTask> = ManagedTask.fetchRequest()
    tasks = try! persistentContainer.viewContext.fetch(request)
  }
}

// add conformance
extension ManagedTask: Identifiable { }

extension ManagedTask {
  enum IntervalType: String, CaseIterable {
    case day, week, month, year
  }
}