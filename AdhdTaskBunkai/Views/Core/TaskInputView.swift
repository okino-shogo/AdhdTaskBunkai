//
//  TaskInputView.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/20.
//

import SwiftUI

struct TaskInputView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var estimatedMinutes = 30
    @State private var startTime = Date()
    @State private var showingSubTaskInput = false
    @State private var subTasks: [SubTask] = []
    
    var body: some View {
        Form {
            Section(header: Text("基本情報")) {
                TextField("タスク名", text: $title)
                TextField("説明", text: $description)
                Stepper("予想時間: \(estimatedMinutes)分", value: $estimatedMinutes, in: 5...480, step: 5)
                DatePicker("開始時間", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
            }
            
            Section(header: Text("サブタスク")) {
                ForEach(subTasks) { subTask in
                    HStack {
                        Text(subTask.title)
                        Spacer()
                        Text("\(subTask.estimatedMinutes)分")
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: deleteSubTask)
                
                Button(action: { showingSubTaskInput = true }) {
                    Label("サブタスクを追加", systemImage: "plus.circle")
                }
            }
        }
        .navigationTitle("新規タスク")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    saveTask()
                }
                .disabled(title.isEmpty)
            }
        }
        .sheet(isPresented: $showingSubTaskInput) {
            SubTaskInputView(subTasks: $subTasks)
        }
    }
    
    private func saveTask() {
        let task = TaskItem(
            title: title,
            description: description,
            estimatedMinutes: estimatedMinutes,
            startTime: startTime,
            subTasks: subTasks
        )
        taskViewModel.addTask(task)
        dismiss()
    }
    
    private func deleteSubTask(at offsets: IndexSet) {
        subTasks.remove(atOffsets: offsets)
    }
}

struct SubTaskInputView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var subTasks: [SubTask]
    
    @State private var title = ""
    @State private var estimatedMinutes = 15
    
    var body: some View {
        NavigationView {
            Form {
                TextField("サブタスク名", text: $title)
                Stepper("予想時間: \(estimatedMinutes)分", value: $estimatedMinutes, in: 5...120, step: 5)
            }
            .navigationTitle("サブタスク追加")
            .navigationBarItems(
                leading: Button("キャンセル") {
                    dismiss()
                },
                trailing: Button("追加") {
                    let subTask = SubTask(
                        title: title,
                        estimatedMinutes: estimatedMinutes
                    )
                    subTasks.append(subTask)
                    dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
}

#Preview {
    NavigationView {
        TaskInputView()
            .environmentObject(TaskViewModel())
    }
}
