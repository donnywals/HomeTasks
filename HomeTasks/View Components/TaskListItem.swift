//
//  TaskListItem.swift
//  HomeTasks
//
//  Created by Donny Wals on 26/06/2020.
//

import SwiftUI

struct TaskListItem: View {
  let task: TaskModel
  
  static let taskDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
  }()
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(task.name)
          .font(Font.system(size: 18))
          .fontWeight(.bold)
        
        Text(task.nextDueDate!, style: .date)
        
        Text("Every \(task.interval) \(task.intervalType.rawValue)")
      }
      Spacer()
    }
  }
}
