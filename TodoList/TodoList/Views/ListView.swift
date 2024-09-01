//
//  ListIView.swift
//  TodoList
//
//  Created by Nicholas Rebello on 2024-08-19.
//

import SwiftUI
import UserNotifications


struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var showCompletedTasks: Bool = false
    @State private var showClearCompletedAlert: Bool = false
    let brown = Color("brown")
    let brown2 = Color("brown2")
    var progress: Double {
        let totalTasks = listViewModel.items.count + listViewModel.completedItems.count
        return totalTasks == 0 ? 0.0 : Double(listViewModel.completedItems.count) / Double(totalTasks)
        
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [brown2.opacity(0.2), brown.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            VStack {
                if listViewModel.items.isEmpty && listViewModel.completedItems.isEmpty {
                    NoItemsView()
                        .transition(AnyTransition.opacity.animation(.easeIn))
                } else {
                    
                    if !listViewModel.items.isEmpty || !listViewModel.completedItems.isEmpty {
                        ProgressView("Tasks Completion", value: progress)
                            .padding()
                    }
                    
                    List {
                        // Active Tasks Section
                        Section(header: Text("Active Tasks")) {
                            ForEach(listViewModel.items) { item in
                                ListRowView(item: item)
                                    .onTapGesture {
                                        withAnimation(.linear) {
                                            listViewModel.updateItem(item: item)
                                        }
                                    }
                            }
                            .onDelete { indexSet in
                                listViewModel.deleteItem(indexSet: indexSet, isCompleted: false)
                            }
                            .onMove(perform: listViewModel.moveItem)
                        }
                        
                        // Completed Tasks Section
                        
                        Section(header: Text("Completed Tasks")) {
                            ForEach(listViewModel.completedItems) { item in
                                ListRowView(item: item)
                                    .onTapGesture {
                                        withAnimation(.linear) {
                                            listViewModel.updateItem(item: item)
                                        }
                                    }
                            }
                            .onDelete { indexSet in
                                listViewModel.deleteItem(indexSet: indexSet, isCompleted: true)
                            }
                        }
                        
                    }
                    .listStyle(PlainListStyle())
                }
                Spacer()
                
                if !listViewModel.completedItems.isEmpty {
                    Button(action: {
                        showClearCompletedAlert = true
                    }) {
                        Text("Clear Completed Tasks")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .alert(isPresented: $showClearCompletedAlert) {
                        Alert(
                            title: Text("Clear Completed Tasks"),
                            message: Text("Are you sure you want to remove all completed tasks?"),
                            primaryButton: .destructive(Text("Clear")) {
                                listViewModel.clearCompletedTasks()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .padding(.bottom, 20)
                    .transition(AnyTransition.opacity.animation(.easeIn))
                }
            }
        }
        .navigationTitle("2-Do List")
        .navigationBarItems(
            leading: EditButton(),
            trailing: NavigationLink("Add", destination: AddView())
        )
        
        
    }
    
}




#Preview {
    NavigationView {
        ListView()
    }
    .environmentObject(ListViewModel())
}
