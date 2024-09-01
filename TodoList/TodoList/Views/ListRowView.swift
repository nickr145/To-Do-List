//
//  ListRowView.swift
//  TodoList
//
//  Created by Nicholas Rebello on 2024-08-19.
//

import SwiftUI
import UserNotifications


struct ListRowView: View {
    
    let item: ItemModel
    
    var body: some View {
        let isOverdue: Bool = {
            if let dueDate = item.dueDate {
                return dueDate < Date() && !item.isCompleted
            }
            return false
        }()
        
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(item.isCompleted ? .green : .red)
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.title2)
                    .foregroundColor(isOverdue ? .red : .primary)
                
                if let dueDate = item.dueDate {
                    Text("Due: \(dueDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(isOverdue ? .red : .green)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2)) // Light grey background
        .listRowInsets(EdgeInsets()) // Remove default list row padding
    }
}

#Preview {
    Group {
        ListRowView(item: ItemModel(title: "This is the first item", isCompleted: false))
        ListRowView(item: ItemModel(title: "This is the second item", isCompleted: true))
    }
    .previewLayout(.sizeThatFits)
}
