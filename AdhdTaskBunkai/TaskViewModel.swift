//
//  TaskViewModel.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/20.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []

    // シングルトンにするか、環境オブジェクトにするかはお好みで
    static let shared = TaskViewModel()

    // タスク追加
    func addTask(title: String) {
        let newTask = TaskItem(title: title)
        tasks.append(newTask)
    }

    // タスク分解API呼び出し
    func breakDownTask(index: Int, apiPrompt: String) {
        Task {
            do {
                // 例: OpenAIに「サブタスクに分解してください」というプロンプトを送る
                let resultText = try await OpenAIAPI.shared.fetchTaskBreakdown(prompt: apiPrompt)

                // 改行で分割してサブタスクを作成
                let lines = resultText
                    .components(separatedBy: .newlines)
                    .filter { !$0.isEmpty }

                // メインスレッドでUI更新
                DispatchQueue.main.async {
                    // タスクの該当indexにサブタスクをセット
                    self.tasks[index].subtasks = lines.map { TaskItem(title: $0) }
                }
            } catch {
                print("分解APIエラー: \(error)")
            }
        }
    }

    // タスク並び替え
    func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }

    // サブタスクの並び替え（必要に応じて）
    // func moveSubtask(...){...}
}


#Preview {
    TaskViewModel()
}
