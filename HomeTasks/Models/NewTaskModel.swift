//
//  NewTaskModel.swift
//  HomeTasks
//
//  Created by Donny Wals on 26/06/2020.
//

import Foundation

struct NewTaskModel {
  var name = ""
  var interval = 1
  var intervalType = ManagedTask.IntervalType.day
  var shouldNotify = true
  var firstOccurrence = Date().addingTimeInterval(3600)
}
