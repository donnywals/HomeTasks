//
//  NewTaskModel.swift
//  HomeTasks
//
//  Created by Donny Wals on 26/06/2020.
//

import Foundation

struct TaskModel: Identifiable {
  var id: UUID?
  var name = ""
  var interval = 1
  var intervalType = ManagedTask.IntervalType.day
  var shouldNotify = true
  var firstOccurrence = Date().addingTimeInterval(3600)
  var nextDueDate: Date?
  var completions: [TaskCompletion] = []
}

extension TaskModel {
  init(task: ManagedTask) {
    id = task.id
    name = task.name!
    interval = Int(task.interval)
    intervalType = task.intervalType
    shouldNotify = task.shouldNotify
    firstOccurrence = task.firstOccurrence!
    nextDueDate = task.nextDueDate!
    
    if let managedCompletions = task.completions?.allObjects as? [ManagedTaskCompletion] {
      completions = managedCompletions
        .map(TaskCompletion.init)
        .sorted(by: { lhs, rhs in lhs.completedOn > rhs.completedOn })
    } else {
      completions = []
    }
  }
}

struct TaskCompletion: Identifiable {
  let id: UUID
  let completedOn: Date
  var notes: String
}

extension TaskCompletion {
  init(taskCompletion: ManagedTaskCompletion) {
    id = taskCompletion.id!
    completedOn = taskCompletion.completedOn!
    notes = taskCompletion.notes!
  }
}
