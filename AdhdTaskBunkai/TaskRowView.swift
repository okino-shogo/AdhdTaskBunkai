//
//  TaskRowView.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/20.
//

import SwiftUI

struct TaskRowView: View {
    @Binding var task: TaskItem
    let index: Int

    @ObservedObject var viewModel = TaskViewModel.shared

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // ドラッグハンドル風アイコン (※実際のドラッグ機能はカスタム実装要)
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .foregroundColor(.gray)
                    .padding(.trailing, 4)

                // タスクタイトル
                Text(task.title)
                    .font(.body)

                Spacer()

                // 「分解」ボタン
                Button {
                    let prompt = "次のタスクを実行可能なサブタスクに分解してください: \(task.title)"
                    viewModel.breakDownTask(index: index, apiPrompt: prompt)
                } label: {
                    Image(systemName: "wand.and.stars.inverse")
                        .foregroundColor(.blue)
                }
            }

            // サブタスクがあれば表示（例：チェックボックスつきリスト）
            if !task.subtasks.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(task.subtasks, id: \.id) { subtask in
                        HStack {
                            Image(systemName: subtaskIsCompleted(subtask) ? "checkmark.square" : "square")
                                .foregroundColor(.blue)
                            Text(subtask.title)
                        }
                        .padding(.leading, 20)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }

    // サブタスクが完了したかどうかを判定する関数（例）
    func subtaskIsCompleted(_ subtask: TaskItem) -> Bool {
        // 必要に応じて完了フラグをTaskItemに追加し、ここで判定
        return false
    }
}

#Preview {
    TaskRowView()
}
