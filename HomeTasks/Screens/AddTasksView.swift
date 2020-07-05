//
//  AddTasksView.swift
//  HomeTasks
//
//  Created by Donny Wals on 26/06/2020.
//

import SwiftUI

struct AddTaskView: View {
  @ObservedObject var taskStore: TaskStore
  
  @State private var taskInfo = TaskModel()
  
  @Environment(\.presentationMode) private var presentationMode
  
  var body: some View {
    NavigationView {
      TaskForm(taskInfo: $taskInfo)
        .navigationTitle("New task")
        .navigationBarItems(
          leading: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
          }, trailing: Button("Save") {
            taskStore.updateOrCreateTask(fromModel: taskInfo)
            presentationMode.wrappedValue.dismiss()
          })
    }
  }
}
