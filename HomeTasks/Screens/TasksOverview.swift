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
  
  var body: some View {
    NavigationView {
      
      List {
        Section(header: Text("Due soon")) {
          ForEach(taskStore.tasks) { task in
            NavigationLink(destination: TaskDetailView(task: task, taskStore: taskStore)) {
              TaskListItem(task: task)
            }
          }
        }
        
        Section(header: Text("Due later")) {
          ForEach(taskStore.tasks) { task in
            TaskListItem(task: task)
          }
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle(Text("Tasks"))
      .navigationBarItems(trailing: Button("Add") {
        isAddingTask = true
      })
      .sheet(isPresented: $isAddingTask) {
        AddTaskView(taskStore: taskStore)
      }
    }
  }
}
