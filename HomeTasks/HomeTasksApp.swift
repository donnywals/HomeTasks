//
//  HomeTasksApp.swift
//  HomeTasks
//
//  Created by Donny Wals on 24/06/2020.
//

import SwiftUI
import CoreData

@main
struct HomeTasksApp: App {
  let persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "HomeTasks")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()
  
  @StateObject var taskStore: TaskStore
  
  init() {
    // Cannot assign to property: taskStore is a get-only property
    let s = TaskStore(persistentContainer: persistentContainer)
    self._taskStore = StateObject(wrappedValue: s)
  }
  
  var body: some Scene {
    WindowGroup {
      TasksOverview(taskStore: taskStore)
        .accentColor(.orange)
    }
  }
}
