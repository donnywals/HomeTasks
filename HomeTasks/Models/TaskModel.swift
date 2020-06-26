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
}

extension TaskModel {
  init(task: ManagedTask) {
    id = task.id
    name = task.name!
    interval = Int(task.interval)
    intervalType = task.intervalType
    shouldNotify = task.shouldNotify
    firstOccurrence = task.firstOccurrence!
  }
}
