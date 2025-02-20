//
//  TaskListView.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/20.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel = TaskViewModel.shared

    var body: some View {
        List {
            ForEach(viewModel.tasks.indices, id: \.self) { index in
                TaskRowView(task: $viewModel.tasks[index], index: index)
            }
            .onMove(perform: viewModel.moveTask)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("タスク一覧")
        .toolbar {
            // Editボタン（ListのonMoveを有効にするため）
            EditButton()
        }
    }
}

#Preview {
    TaskListView()
}
