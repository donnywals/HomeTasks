//
//  ContentView.swift
//  HomeTasks
//
//  Created by Donny Wals on 24/06/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @ObservedObject var taskStore: TaskStore  
  @State private var isAddingTask = false
  
  var body: some View {
    NavigationView {
      
      List {
        Section(header: Text("Due soon")) {
          ForEach(taskStore.tasks) { task in
            NavigationLink(destination: TaskDetailView(task: task, taskStore: taskStore)) {
              HStack {
                Text(task.name!)
                Spacer()
                Image(systemName: "circle")
              }
            }
          }
        }
        
        Section(header: Text("Due later")) {
          ForEach(taskStore.tasks) { task in
            HStack {
              Text(task.name!)
              Spacer()
              Image(systemName: "circle")
            }
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

struct TaskDetailView: View {
  let task: ManagedTask
  @ObservedObject var taskStore: TaskStore
  
  var body: some View {
    VStack {
      Text(task.name!)
      
      List {
        Section(header: Text("History")) {
          ForEach(1...10, id: \.self) { i in
            Text("History entry \(i)")
          }
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle(Text(task.name!))
    }
  }
}

struct AddTaskView: View {
  @ObservedObject var taskStore: TaskStore
  
  @State private var taskName = ""
  @State private var taskInterval = 1
  @State private var intervalType = ManagedTask.IntervalType.day
  @State private var shouldNotify = true
  @State private var firstTaskDate = Date().addingTimeInterval(3600)
  
  @Environment(\.presentationMode) private var presentationMode
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Task name")) {
          TextField("task name", text: $taskName)
        }
        
        Section(header: Text("Task frequency")) {
          Text("This task should be done every:")
          Stepper("\(taskInterval)", value: $taskInterval, in: 1...99)
          Picker("", selection: $intervalType) {
            ForEach(ManagedTask.IntervalType.allCases, id: \.self) { intervalType in
              Text(intervalType.rawValue)
            }
          }.pickerStyle(SegmentedPickerStyle())
        }
        
        Section(header: Text("First task occurrence")) {
          DatePicker("First due date", selection: $firstTaskDate, displayedComponents: [.date])
        }
        
        Section(header: Text("Notifications")) {
          HStack {
            Toggle("Notify at 09:00am on task due day", isOn: $shouldNotify)
          }
        }
      }
      .navigationTitle("New task")
      .navigationBarItems(
        leading: Button("Cancel") {
          presentationMode.wrappedValue.dismiss()
        }, trailing: Button("Save") {
          taskStore.addTask(withName: taskName)
          presentationMode.wrappedValue.dismiss()
        })
    }.accentColor(.orange)
  }
}
