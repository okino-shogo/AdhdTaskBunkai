//
//  TaskViewModel.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/20.
//

import Foundation
import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskItem]
    @Published var selectedTask: TaskItem?
    @Published var isAddingNewTask = false
    @Published var isShowingTaskDetail = false
    
    init() {
        self.tasks = TaskItem.mockTasks
    }
    
    // MARK: - Task Management
    func addTask(_ task: TaskItem) {
        tasks.append(task)
    }
    
    func updateTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func completeTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted = true
        }
    }
    
    // MARK: - AI Task Breakdown
    func breakdownTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].subTasks = [
                SubTask(title: "ステップ1: 目標の明確化", estimatedMinutes: 15),
                SubTask(title: "ステップ2: 必要な情報収集", estimatedMinutes: 30),
                SubTask(title: "ステップ3: 実行計画の作成", estimatedMinutes: 20),
                SubTask(title: "ステップ4: タスクの実施", estimatedMinutes: 60),
                SubTask(title: "ステップ5: 振り返りと修正", estimatedMinutes: 15)
            ]
            updateTask(tasks[index])
        }
    }
}

struct TaskViewModelPreview: View {
    @StateObject private var taskViewModel = TaskViewModel()
    
    var body: some View {
        Text("TaskViewModel Preview")
            .environmentObject(taskViewModel)
    }
}

#Preview {
    TaskViewModelPreview()
}
