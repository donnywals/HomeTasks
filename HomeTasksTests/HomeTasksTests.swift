//
//  HomeTasksTests.swift
//  HomeTasksTests
//
//  Created by Donny Wals on 26/07/2020.
//

import XCTest
import CoreData
@testable import HomeTasks

class HomeTasksTests: XCTestCase {
  func testExample() throws {
    let container = TaskStore(.inMemory)
    
    let decoder = JSONDecoder()
    decoder.userInfo[CodingUserInfoKey.managedObjectContext] = container.persistentContainer.viewContext
    do {
      let items = try decoder.decode([TodoItem].self, from: json)
      print(items)
      XCTAssert(items.count == 2)
    } catch {
      print(error)
    }
  }
}

let json = """
[
  {
    "id": 0,
    "label": "Item 0",
    "completions": []
  },
  {
    "id": 1,
    "label": "Item 1",
    "completions": [
      {
        "completionDate": 767645378
      }
    ]
  }
]
""".data(using: .utf8)!
