import SwiftUI

struct TaskDetailView: View {
    let task: TaskItem
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isProcessingAI = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(task.description)
                            .font(.body)
                        
                        HStack {
                            Image(systemName: "clock")
                            Text("予定時間: \(task.estimatedMinutes)分")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    ForEach(task.subTasks) { subtask in
                        HStack {
                            Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(subtask.isCompleted ? .green : .secondary)
                            
                            VStack(alignment: .leading) {
                                Text(subtask.title)
                                    .strikethrough(subtask.isCompleted)
                                Text("\(subtask.estimatedMinutes)分")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Button {
                        isProcessingAI = true
                        taskViewModel.breakdownTask(task)
                        isProcessingAI = false
                    } label: {
                        if isProcessingAI {
                            HStack {
                                ProgressView()
                                Text("AIが分解中...")
                            }
                        } else {
                            Label("AIで分解", systemImage: "wand.and.stars")
                        }
                    }
                    .disabled(isProcessingAI)
                } header: {
                    Text("サブタスク")
                } footer: {
                    Text("AIを使ってタスクをより細かく分解できます")
                }
                
                if !task.isCompleted {
                    Section {
                        Button {
                            taskViewModel.completeTask(task)
                            dismiss()
                        } label: {
                            Label("タスクを完了", systemImage: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationTitle(task.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("閉じる") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    TaskDetailView(task: TaskItem.mockTasks[0])
        .environmentObject(TaskViewModel())
} 
