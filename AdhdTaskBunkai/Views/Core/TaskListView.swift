//
//  TaskListView.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/20.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        List {
            ForEach(taskViewModel.tasks) { task in
                NavigationLink(destination: TaskDetailView(task: task)) {
                    TaskRowView(task: task)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        taskViewModel.deleteTask(task)
                    } label: {
                        Label("削除", systemImage: "trash")
                    }
                    
                    if !task.isCompleted {
                        Button {
                            taskViewModel.completeTask(task)
                        } label: {
                            Label("完了", systemImage: "checkmark")
                        }
                        .tint(.green)
                    }
                }
            }
        }
        .navigationTitle("タスク")
        .toolbar {
            Button {
                taskViewModel.isAddingNewTask = true
            } label: {
                Label("タスクを追加", systemImage: "plus")
            }
        }
        .sheet(isPresented: $taskViewModel.isAddingNewTask) {
            TaskInputView()
        }
    }
}

#Preview {
    NavigationView {
        TaskListView()
            .environmentObject(TaskViewModel())
    }
}
