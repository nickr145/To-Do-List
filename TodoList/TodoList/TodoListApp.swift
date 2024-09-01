//
//  TodoListApp.swift
//  TodoList
//
//  Created by Nicholas Rebello on 2024-08-19.
//

import SwiftUI
import UserNotifications


@main
struct TodoListApp: App {
    
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(listViewModel)
        }
    }
}
