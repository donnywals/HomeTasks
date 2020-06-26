//
//  TaskDetailView.swift
//  HomeTasks
//
//  Created by Donny Wals on 26/06/2020.
//

import SwiftUI

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
