//
//  EditTaskView.swift
//  HomeTasks
//
//  Created by Donny Wals on 26/06/2020.
//

import SwiftUI

struct EditTaskView: View {
  @ObservedObject var taskStore: TaskStore
  
  @Binding var taskInfo: TaskModel
  
  @Environment(\.presentationMode) private var presentationMode
  
  var body: some View {
    NavigationView {
      TaskForm(taskInfo: $taskInfo)
        .navigationTitle(taskInfo.name)
        .navigationBarItems(
          leading: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
          }, trailing: Button("Save") {
            taskStore.updateOrCreateTask(fromModel: taskInfo)
            presentationMode.wrappedValue.dismiss()
          })
    }.accentColor(.orange)
  }
}
