//
//  AddTasksView.swift
//  HomeTasks
//
//  Created by Donny Wals on 26/06/2020.
//

import SwiftUI

struct AddTaskView: View {
  @ObservedObject var taskStore: TaskStore
  
  @State var taskInfo = NewTaskModel()
  
  @Environment(\.presentationMode) private var presentationMode
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Task name")) {
          TextField("task name", text: $taskInfo.name)
        }
        
        Section(header: Text("Task frequency")) {
          Text("This task should be done every:")
          Stepper("\(taskInfo.interval)", value: $taskInfo.interval, in: 1...99)
          Picker("", selection: $taskInfo.intervalType) {
            ForEach(ManagedTask.IntervalType.allCases, id: \.self) { intervalType in
              Text(intervalType.rawValue)
            }
          }.pickerStyle(SegmentedPickerStyle())
        }
        
        Section(header: Text("First task occurrence")) {
          DatePicker("First due date", selection: $taskInfo.firstOccurrence, displayedComponents: [.date])
        }
        
        Section(header: Text("Notifications")) {
          HStack {
            Toggle("Notify at 09:00am on task due day", isOn: $taskInfo.shouldNotify)
          }
        }
      }
      .navigationTitle("New task")
      .navigationBarItems(
        leading: Button("Cancel") {
          presentationMode.wrappedValue.dismiss()
        }, trailing: Button("Save") {
          taskStore.addTask(fromModel: taskInfo)
          presentationMode.wrappedValue.dismiss()
        })
    }.accentColor(.orange)
  }
}
