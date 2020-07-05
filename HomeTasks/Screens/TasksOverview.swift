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
          ForEach(taskStore.tasks) { task in
            NavigationLink(destination: TaskDetailView(task: task, taskStore: taskStore), tag: task.id!, selection: $activeUUID) {
              TaskListItem(task: task)
            }
          }.onDelete(perform: { indexSet in
            for index in indexSet {
              let task = taskStore.tasks[index]
              taskStore.delete(task)
            }
          })
        }
        
        Section(header: Text("Due later")) {
          ForEach(taskStore.tasks) { task in
            TaskListItem(task: task)
          }
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
        print(taskStore.tasks.first!.id!)
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
