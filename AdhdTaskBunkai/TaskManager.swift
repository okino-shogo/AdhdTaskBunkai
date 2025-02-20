//
//  TaskManager.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/20.
//

import Foundation

class TaskManager: ObservableObject {
    static let shared = TaskManager()

    @Published var subTasks: [String] = []

    func breakDownTask(_ taskText: String) {
        // 非同期タスクを生成してバックグラウンドでAPI呼び出しを行う
        Task {
            do {
                // 入力されたタスク内容を含むプロンプトを生成
                let prompt = "次のタスクを実行可能なサブタスクに分解してください：\(taskText)"
                // OpenAI APIから結果を取得
                let result = try await OpenAIAPI.shared.fetchTaskBreakdown(prompt: prompt)

                // レスポンステキストを改行で分割してサブタスクの配列に変換
                let tasks = result.components(separatedBy: "\n").filter { !$0.isEmpty }
                // メインスレッドでUI更新
                DispatchQueue.main.async {
                    self.subTasks = tasks
                }
            } catch {
                print("タスク分解API呼び出しエラー: \(error)")
            }
        }
    }
}
