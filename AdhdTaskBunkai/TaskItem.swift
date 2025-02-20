//
//  TaskItem.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/20.
//

import Foundation

struct TaskItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var subtasks: [TaskItem] = []
    // 例: 完了状況や優先度などを追加してもOK
}

