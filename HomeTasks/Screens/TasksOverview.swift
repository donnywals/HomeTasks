//
//  TasksOverview.swift
//  HomeTasks
//
//  Created by Donny Wals on 26/06/2020.
//

import SwiftUI

struct TasksOverview: View {
  @ObservedObject var taskStore: TaskStore
  @State private var isAddingTask = false
  @EnvironmentObject var notificationHandler: NotificationHandler
  
  @State var activeUUID: UUID?
  
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Due soon")) {
          ForEach(taskStore.tasksDueSoon) { task in
            NavigationLink(destination: TaskDetailView(task: task, taskStore: taskStore), tag: task.id!, selection: $activeUUID) {
              TaskListItem(task: task)
            }
          }.onDelete(perform: { indexSet in
            for index in indexSet {
              let task = taskStore.tasksDueSoon[index]
              taskStore.delete(task)
            }
          })
        }
        
        Section(header: Text("Due later")) {
          ForEach(taskStore.tasksDueLater) { task in
            NavigationLink(destination: TaskDetailView(task: task, taskStore: taskStore), tag: task.id!, selection: $activeUUID) {
              TaskListItem(task: task)
            }
          }.onDelete(perform: { indexSet in
            for index in indexSet {
              let task = taskStore.tasksDueLater[index]
              taskStore.delete(task)
            }
          })
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle(Text("Tasks"))
      .navigationBarItems(
        leading: Button("Ping!") {
          notificationHandler.addDummyNotification()
        },
        trailing: Button("Add") {
          isAddingTask = true
        })
      .onOpenURL(perform: { url in
        if case .task(let id) = url.appSection {
          activeUUID = id
        }
      })
      .sheet(isPresented: $isAddingTask) {
        AddTaskView(taskStore: taskStore)
      }
    }
  }
}
