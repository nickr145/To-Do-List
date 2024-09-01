//
//  ItemModel.swift
//  TodoList
//
//  Created by Nicholas Rebello on 2024-08-19.
//

import Foundation
import UserNotifications

struct ItemModel: Identifiable, Codable {
    let id: String
    let title: String
    let isCompleted: Bool
    let dueDate: Date?
    
    init(id: String = UUID().uuidString, title: String, isCompleted: Bool, dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        
    }
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: !isCompleted, dueDate: dueDate)
    }
}
