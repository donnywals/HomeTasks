//
//  TaskDetailView.swift
//  HomeTasks
//
//  Created by Donny Wals on 26/06/2020.
//

import SwiftUI

struct TaskDetailView: View {
  @ObservedObject var taskStore: TaskStore
  @State private var task: TaskModel
  
  @State private var isEditing = false
  
  init(task: TaskModel, taskStore: TaskStore) {
    self._task = State(initialValue: task)
    self.taskStore = taskStore
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      TopSection(task: $task, taskStore: taskStore)
      
      List {
        Section(header: Text("History")) {
          ForEach(task.completions) { completion in
            Text("\(completion.completedOn, style: .date) \(completion.completedOn, style: .time)")
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
    @Binding var task: TaskModel
    @ObservedObject var taskStore: TaskStore
    
    var body: some View {
      VStack(alignment: .leading, spacing: 4) {
        Text(task.name)
          .font(.title)
        Text(task.nextDueDate ?? task.firstOccurrence, style: .date)
          .font(.subheadline)
        
        Text("Every \(task.interval) \(task.intervalType.rawValue)")
        Text("Notifications are \(task.shouldNotify ? "on" : "off")")
        
        Button("Task completed") {
          taskStore.createCompletion(for: $task)
        }
      }
      .padding()
    }
  }
}
