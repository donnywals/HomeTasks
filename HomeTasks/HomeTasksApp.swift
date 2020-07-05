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
  
  let notificationHandler = NotificationHandler()
  
  @StateObject var taskStore: TaskStore
  
  init() {
    let s = TaskStore(persistentContainer: persistentContainer)
    self._taskStore = StateObject(wrappedValue: s)
  }
  
  var body: some Scene {
    WindowGroup {
      TasksOverview(taskStore: taskStore)
        .environmentObject(notificationHandler)
        .accentColor(.orange)
        .onOpenURL(perform: { url in
          print("asked to open url: \(url)")
        })
    }
  }
}
