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
  @State var activeTab = TabIdentifier.tasksOverview
  
  init() {
    let s = TaskStore(persistentContainer: persistentContainer)
    self._taskStore = StateObject(wrappedValue: s)
  }
  
  var body: some Scene {
    WindowGroup {
      TabView(selection: $activeTab) {
        TasksOverview(taskStore: taskStore)
          .tabItem {
            VStack {
              Image(systemName: "list.star")
              Text("Tasks")
            }
          }
          .tag(TabIdentifier.tasksOverview)
        
        SettingsView()
          .tabItem {
            VStack {
              Image(systemName: "gearshape")
              Text("Settings")
            }
          }
          .tag(TabIdentifier.settings)
      }
      .environmentObject(notificationHandler)
      .accentColor(.orange)
      .onOpenURL(perform: { url in
        if case .settings = url.appSection {
          activeTab = .settings
        } else if case .tasksOverview = url.appSection {
          activeTab = .tasksOverview
        } else if case .task = url.appSection {
          activeTab = .tasksOverview
        }
      })
    }
  }
}

extension HomeTasksApp {
  enum TabIdentifier: String {
    case tasksOverview, settings
  }
}

struct MyApplication: App {
  @State var activeTab = TabIdentifier.home
  
  var body: some Scene {
    WindowGroup {
      TabView(selection: $activeTab) {
        HomeView()
          .tabItem {
            VStack {
              Image(systemName: "house")
              Text("Home")
            }
          }
          .tag(TabIdentifier.home) // use enum case as tag
        
        SettingsView()
          .tabItem {
            VStack {
              Image(systemName: "gearshape")
              Text("Settings")
            }
          }
          .tag(TabIdentifier.settings) // use enum case as tag
      }
      .onOpenURL { url in
        guard let tabIdentifier = url.tabIdentifier else {
          return
        }
        
        activeTab = tabIdentifier
      }
    }
  }
}

struct HomeView: View {
  var body: some View {
    Text("Hello, world!")
  }
}
