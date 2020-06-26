//
//  TaskDetailView.swift
//  HomeTasks
//
//  Created by Donny Wals on 26/06/2020.
//

import SwiftUI

struct TaskDetailView: View {
  @State private var task: TaskModel
  @State private var isEditing = false
  @ObservedObject var taskStore: TaskStore
  
  init(task: TaskModel, taskStore: TaskStore) {
    self._task = State(initialValue: task)
    self.taskStore = taskStore
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      TopSection(task: task)
      
      List {
        Section(header: Text("History")) {
          ForEach(0..<10, id: \.self) { _ in
            Text("Item")
          }
        }
      }
      .listStyle(InsetGroupedListStyle())
      
    }
    .navigationTitle(Text(task.name))
    .navigationBarItems(trailing: Button("Edit") {
      isEditing.toggle()
    })
    .sheet(isPresented: $isEditing) {
      EditTaskView(taskStore: taskStore, taskInfo: $task)
    }
  }
}

extension TaskDetailView {
  struct TopSection: View {
    let task: TaskModel
    
    var body: some View {
      VStack(alignment: .leading, spacing: 4) {
        Text(task.name)
          .font(.title)
        Text(task.firstOccurrence, style: .date)
          .font(.subheadline)
        
        Text("Every \(task.interval) \(task.intervalType.rawValue)")
        Text("Notifications are \(task.shouldNotify ? "on" : "off")")
      }
      .padding()
    }
  }
}
