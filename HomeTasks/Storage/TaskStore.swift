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

enum StorageType {
  case persistent, inMemory
}

class TaskStore: ObservableObject {
  @Published var tasksDueSoon: [TaskModel]
  @Published var tasksDueLater: [TaskModel]
  
  let persistentContainer: NSPersistentContainer
  
  init(_ storageType: StorageType) {
    self.persistentContainer = NSPersistentContainer(name: "HomeTasks")
    
    if storageType == .inMemory {
      let description = NSPersistentStoreDescription()
      description.type = NSInMemoryStoreType
      self.persistentContainer.persistentStoreDescriptions = [description]
    }
    
    self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    
    self.tasksDueSoon = []
    self.tasksDueLater = []
    
    updateTasks()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(managedObjectContextSaved(_:)),
                                           name: Notification.Name.NSManagedObjectContextDidSave,
                                           object: persistentContainer.viewContext)
  }
  
  func updateOrCreateTask(fromModel model: TaskModel) {
    if model.id == nil {
      createTask(fromModel: model)
    } else {
      updateTask(fromModel: model)
    }
    
    persistentContainer.viewContext.saveOrRollback()
  }
  
  func delete(_ model: TaskModel) {
    guard let id = model.id else { return }
    
    let request: NSFetchRequest<NSFetchRequestResult> = ManagedTask.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
    
    _ = try! persistentContainer.viewContext.execute(deleteRequest)
    persistentContainer.viewContext.saveOrRollback()
  }
  
  func createCompletion(for task: Binding<TaskModel>) {
    guard let managedTask = managedTask(for: task.wrappedValue) else {
      fatalError("Attempt to create completion for non-existing task")
    }
    
    let completion = ManagedTaskCompletion(context: persistentContainer.viewContext)
    completion.id = UUID()
    completion.completedOn = Date()
    completion.notes = ""
    completion.task = managedTask
    
    managedTask.nextDueDate = determineNextDueDate(for: task.wrappedValue)
    
    persistentContainer.viewContext.saveOrRollback()
    
    task.wrappedValue = TaskModel(task: managedTask)
  }
  
  private func createTask(fromModel model: TaskModel) {
    let task = ManagedTask(context: persistentContainer.viewContext)
    task.id = UUID()
    
    apply(model: model, to: task)
    task.nextDueDate = determineNextDueDate(for: model)
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
    task.nextDueDate = model.nextDueDate
  }
  
  private func updateTasks() {
    let request: NSFetchRequest<ManagedTask> = ManagedTask.fetchRequest()
    
    var dateComponents = DateComponents()
    dateComponents.weekOfYear = 2
    let dueSoonCutoff = Calendar.current.date(byAdding: dateComponents, to: Date()) ?? Date()
    
    request.predicate = NSPredicate(format: "nextDueDate < %@", dueSoonCutoff as CVarArg)
    tasksDueSoon = try! persistentContainer.viewContext.fetch(request).map(TaskModel.init)
    
    request.predicate = NSPredicate(format: "nextDueDate >= %@", dueSoonCutoff as CVarArg)
    tasksDueLater = try! persistentContainer.viewContext.fetch(request).map(TaskModel.init)
  }
  
  private func managedTask(for task: TaskModel) -> ManagedTask? {
    guard let id = task.id else { return nil }
    
    let request: NSFetchRequest<ManagedTask> = ManagedTask.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    
    guard let tasks = try? persistentContainer.viewContext.fetch(request),
          let task = tasks.first, tasks.count == 1 else { return nil }
    
    return task
  }
  
  private func determineNextDueDate(for task: TaskModel) -> Date {
    guard let currentNextDueDate = task.nextDueDate else {
      return task.firstOccurrence
    }
    
    var components = DateComponents()
    switch task.intervalType {
    case .day:
      components.day = task.interval
    case .week:
      components.weekOfYear = task.interval
    case .month:
      components.month = task.interval
    case .year:
      components.year = task.interval
    }
    
    var next = currentNextDueDate
    repeat {
      next = Calendar.current.date(byAdding: components, to: next)!
    } while next <= Date()
    
    return next
  }
}

extension TaskStore {
  @objc func managedObjectContextSaved(_ notification: Notification) {
    updateTasks()
  }
}

extension ManagedTask {
  enum IntervalType: String, CaseIterable {
    case day, week, month, year
  }
  
  var intervalType: IntervalType {
    return IntervalType(rawValue: rawIntervalType ?? "week") ?? .week
  }
}
