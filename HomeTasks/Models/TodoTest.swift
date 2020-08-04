//
//  TodoTest.swift
//  HomeTasks
//
//  Created by Donny Wals on 03/08/2020.
//

import Foundation
import CoreData

class TodoCompletion: NSManagedObject, Codable {
  enum CodingKeys: CodingKey {
    case completionDate
  }
  
  required convenience init(from decoder: Decoder) throws {
    guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
      throw DecoderConfigurationError.missingManagedObjectContext
    }
    
    self.init(context: context)
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.completionDate = try container.decode(Date.self, forKey: .completionDate)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(completionDate, forKey: .completionDate)
  }
}

class TodoItem: NSManagedObject, Codable {
  enum CodingKeys: CodingKey {
    case id, label, completions
  }

  required convenience init(from decoder: Decoder) throws {
    guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
      throw DecoderConfigurationError.missingManagedObjectContext
    }

    self.init(context: context)

    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int64.self, forKey: .id)
    self.label = try container.decode(String.self, forKey: .label)
    self.completions = try container.decode(Set<TodoCompletion>.self, forKey: .completions) as NSSet
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(label, forKey: .label)
    try container.encode(completions as! Set<TodoCompletion>, forKey: .completions)
  }
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}
