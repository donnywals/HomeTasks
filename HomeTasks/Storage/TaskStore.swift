//
//  TasksStore.swift
//  HomeTasks
//
//  Created by Donny Wals on 24/06/2020.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class TaskStore: ObservableObject {
  @Published var tasks: [TaskModel]
  
  let persistentContainer: NSPersistentContainer
  
  init(persistentContainer: NSPersistentContainer) {
    self.persistentContainer = persistentContainer
    self.tasks = []

    updateTasks()
  }
  
  func updateOrCreateTask(fromModel model: TaskModel) {
    if model.id == nil {
      createTask(fromModel: model)
    } else {
      updateTask(fromModel: model)
    }
    
    try? persistentContainer.viewContext.save()
    
    updateTasks()
  }
  
  private func createTask(fromModel model: TaskModel) {
    let task = ManagedTask(context: persistentContainer.viewContext)
    task.id = UUID()
    
    apply(model: model, to: task)
  }
  
  private func updateTask(fromModel model: TaskModel) {
    guard let id = model.id else { return }
    
    let request: NSFetchRequest<ManagedTask> = ManagedTask.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    
    guard let tasks = try? persistentContainer.viewContext.fetch(request),
          let task = tasks.first, tasks.count == 1 else { return }
    
    apply(model: model, to: task)
  }
  
  private func apply(model: TaskModel, to task: ManagedTask) {
    task.name = model.name
    task.interval = Int64(model.interval)
    task.rawIntervalType = model.intervalType.rawValue
    task.firstOccurrence = model.firstOccurrence
    task.shouldNotify = model.shouldNotify
  }
  
  private func updateTasks() {
    let request: NSFetchRequest<ManagedTask> = ManagedTask.fetchRequest()
    tasks = try! persistentContainer.viewContext.fetch(request).map(TaskModel.init)
  }
}

// add conformance
extension ManagedTask: Identifiable { }

extension ManagedTask {
  enum IntervalType: String, CaseIterable {
    case day, week, month, year
  }
  
  var intervalType: IntervalType {
    return IntervalType(rawValue: rawIntervalType ?? "week") ?? .week
  }
}
