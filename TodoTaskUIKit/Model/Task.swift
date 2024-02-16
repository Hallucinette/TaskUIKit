//
//  Task.swift
//  TodoTaskUIKit
//
//  Created by Amelie Pocchiolo on 15/02/2024.
//

import Foundation

// MARK: - RecordTask
struct Record: Codable {
    let records: [RecordTask]
}

// MARK: - Record
struct RecordTask: Codable {
    let id: String
    let fields: Fields
}

// MARK: - Fields
struct Fields: Codable {
    let task: String
    let done: Bool?
    let toDoBefore: String
    let priority: Priority

    enum CodingKeys: String, CodingKey {
        case task = "Task"
        case done = "Done"
        case toDoBefore = "To do before"
        case priority = "Priority"
    }
}

enum Priority: String, Codable {
    case high = "High"
    case low = "Low"
    case medium = "Medium"
}
