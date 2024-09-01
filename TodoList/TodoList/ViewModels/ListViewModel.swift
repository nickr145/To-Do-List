//
//  ListViewModel.swift
//  TodoList
//
//  Created by Nicholas Rebello on 2024-08-19.
//

import Foundation
import UserNotifications

class ListViewModel: ObservableObject {
    
    @Published var items: [ItemModel] = [] {
        didSet {
            saveitems()
        }
    }
    
    @Published var completedItems: [ItemModel] = [] {
        didSet {
            saveitems()
        }
    }
    
    let itemskey: String = "items_list"
    
    init() {
        requestNotificationPermission()
        getItems()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permission granted")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemskey),
            let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)
        else { return }
        
        // Separate completed and active tasks
        self.items = savedItems.filter { !$0.isCompleted }
        self.completedItems = savedItems.filter { $0.isCompleted }
        
        // Sort active tasks by due date (optional)
        self.items = self.items.sorted {
            guard let firstDate = $0.dueDate, let secondDate = $1.dueDate else { return false }
            return firstDate < secondDate
        }
    }
    
    func deleteItem(indexSet: IndexSet, isCompleted: Bool = false) {
        if isCompleted {
            completedItems.remove(atOffsets: indexSet)
        } else {
            items.remove(atOffsets: indexSet)
        }
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    func addItem(title: String, dueDate: Date?) {
        let newItem = ItemModel(title: title, isCompleted: false, dueDate: dueDate)
        items.append(newItem)
        
        scheduleNotification(for: newItem)
    }
    
    func scheduleNotification(for item: ItemModel) {
        guard let dueDate = item.dueDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Task: \(item.title) is due soon!"
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            let updatedItem = item.updateCompletion()
            if updatedItem.isCompleted {
                items.remove(at: index)
                completedItems.append(updatedItem)
            } else {
                items[index] = updatedItem
            }
        } else if let index = completedItems.firstIndex(where: { $0.id == item.id }) {
            let updatedItem = item.updateCompletion()
            if !updatedItem.isCompleted {
                completedItems.remove(at: index)
                items.append(updatedItem)
            }
        }
    }
    
    func saveitems() {
         let allItems = items + completedItems
         if let encodedData = try? JSONEncoder().encode(allItems) {
             UserDefaults.standard.set(encodedData, forKey: itemskey)
         }
    }
    
    func clearCompletedTasks() {
        completedItems.removeAll()
    }
}
