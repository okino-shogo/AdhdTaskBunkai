//
//  TaskRowView.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/20.
//

import SwiftUI

struct TaskRowView: View {
    let task: TaskItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                Text("\(task.estimatedMinutes)分")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if task.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TaskRowView(task: TaskItem(title: "サンプルタスク", estimatedMinutes: 30))
}
