//
//  TaskItem.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/20.
//

import Foundation

struct TaskItem: Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String
    var isCompleted: Bool
    let estimatedMinutes: Int
    var startTime: Date
    var endTime: Date
    var subTasks: [SubTask]
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        isCompleted: Bool = false,
        estimatedMinutes: Int = 30,
        startTime: Date = Date(),
        endTime: Date? = nil,
        subTasks: [SubTask] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.estimatedMinutes = estimatedMinutes
        self.startTime = startTime
        self.endTime = endTime ?? Calendar.current.date(byAdding: .minute, value: estimatedMinutes, to: startTime) ?? startTime
        self.subTasks = subTasks
    }
    
    static func == (lhs: TaskItem, rhs: TaskItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct SubTask: Identifiable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var estimatedMinutes: Int
    
    init(
        title: String,
        isCompleted: Bool = false,
        estimatedMinutes: Int = 0
    ) {
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.estimatedMinutes = estimatedMinutes
    }
    
    static func == (lhs: SubTask, rhs: SubTask) -> Bool {
        lhs.id == rhs.id
    }
}

struct Location: Codable {
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var travelTimeMinutes: Int?
}

// MARK: - Mock Data
extension TaskItem {
    static let mockTasks = [
        TaskItem(
            title: "プレゼン資料作成",
            description: "来週の会議用のプレゼンテーション資料を作成する",
            estimatedMinutes: 120,
            startTime: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date()) ?? Date(),
            subTasks: [
                SubTask(title: "アウトライン作成", estimatedMinutes: 30),
                SubTask(title: "スライド作成", estimatedMinutes: 60),
                SubTask(title: "原稿作成", estimatedMinutes: 30)
            ]
        ),
        TaskItem(
            title: "買い物に行く",
            description: "週末の食材を購入する",
            estimatedMinutes: 60,
            startTime: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date()) ?? Date(),
            subTasks: [
                SubTask(title: "買い物リスト作成", estimatedMinutes: 10),
                SubTask(title: "スーパーで買い物", estimatedMinutes: 40),
                SubTask(title: "帰宅して片付け", estimatedMinutes: 10)
            ]
        )
    ]
}

