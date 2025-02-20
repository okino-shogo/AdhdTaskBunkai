//
//  TaskInputView.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/20.
//

import SwiftUI

struct TaskInputView: View {
    @State private var newTaskTitle = ""
    @ObservedObject var viewModel = TaskViewModel.shared

    var body: some View {
        HStack {
            TextField("新しいタスクを入力", text: $newTaskTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 200)

            // 追加ボタン
            Button {
                guard !newTaskTitle.isEmpty else { return }
                viewModel.addTask(title: newTaskTitle)
                newTaskTitle = ""
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}


#Preview {
    TaskInputView()
}
