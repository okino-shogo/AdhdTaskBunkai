import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var selectedDate = Date()
    @State private var draggingTask: TaskItem?
    @State private var dragOffset: CGFloat = 0
    @State private var isShowingTaskInput = false
    @State private var selectedTask: TaskItem?
    private let hours = Array(0...23) // 24時間表示
    private let hourHeight: CGFloat = 60
    private let timeIndicatorTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                // 日付選択部分
                HStack {
                    Button(action: { 
                        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                    Text(dateString(from: selectedDate))
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                
                // タイムライン部分
                ScrollView {
                    ZStack(alignment: .topLeading) {
                        // 時間軸
                        VStack(spacing: 0) {
                            ForEach(hours, id: \.self) { hour in
                                VStack(spacing: 0) {
                                    HStack {
                                        Text(String(format: "%02d:00", hour))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .frame(width: 50, alignment: .trailing)
                                        
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 1)
                                    }
                                    .padding(.horizontal)
                                    
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(height: hourHeight - 1)
                                }
                            }
                        }
                        
                        // タスク表示
                        ForEach(taskViewModel.tasks) { task in
                            if Calendar.current.isDate(task.startTime, inSameDayAs: selectedDate) {
                                TaskTimelineItem(task: task, hourHeight: hourHeight)
                                    .position(
                                        x: UIScreen.main.bounds.width / 2,
                                        y: timeToPosition(task.startTime) + (task == draggingTask ? dragOffset : 0)
                                    )
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                draggingTask = task
                                                dragOffset = value.translation.height
                                            }
                                            .onEnded { value in
                                                if let task = draggingTask {
                                                    let newTime = positionToTime(timeToPosition(task.startTime) + value.translation.height)
                                                    updateTaskTime(task, to: newTime)
                                                }
                                                draggingTask = nil
                                                dragOffset = 0
                                            }
                                    )
                                    .onTapGesture {
                                        selectedTask = task
                                    }
                            }
                        }
                        
                        // 現在時刻インジケーター
                        if Calendar.current.isDate(Date(), inSameDayAs: selectedDate) {
                            TimeIndicator(position: timeToPosition(Date()))
                                .onReceive(timeIndicatorTimer) { _ in
                                    // 1分ごとに更新
                                }
                        }
                    }
                }
            }
            
            // 新規タスク追加ボタン
            Button(action: {
                isShowingTaskInput = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                    .background(Circle().fill(Color.white))
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))
        .sheet(isPresented: $isShowingTaskInput) {
            TaskInputView()
                .presentationDetents([.medium])
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailView(task: task)
        }
    }
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
    private func timeToPosition(_ date: Date) -> CGFloat {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return CGFloat(hour) * hourHeight + CGFloat(minute) / 60.0 * hourHeight
    }
    
    private func positionToTime(_ position: CGFloat) -> Date {
        let hour = Int(position / hourHeight)
        let minute = Int((position.truncatingRemainder(dividingBy: hourHeight) / hourHeight) * 60)
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: selectedDate) ?? selectedDate
    }
    
    private func updateTaskTime(_ task: TaskItem, to newTime: Date) {
        var updatedTask = task
        let duration = Calendar.current.dateComponents([.minute], from: task.startTime, to: task.endTime).minute ?? 0
        updatedTask.startTime = newTime
        updatedTask.endTime = Calendar.current.date(byAdding: .minute, value: duration, to: newTime) ?? newTime
        taskViewModel.updateTask(updatedTask)
    }
}

struct TaskTimelineItem: View {
    let task: TaskItem
    let hourHeight: CGFloat
    
    var body: some View {
        let duration = Calendar.current.dateComponents([.minute], from: task.startTime, to: task.endTime).minute ?? 0
        let height = CGFloat(duration) / 60.0 * hourHeight
        
        VStack(alignment: .leading) {
            Text(task.title)
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(2)
            Text("\(duration)分")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: UIScreen.main.bounds.width * 0.7, height: height)
        .padding(8)
        .background(task.isCompleted ? Color.green : Color.blue)
        .cornerRadius(8)
        .padding(.leading, 50)
    }
}

struct TimeIndicator: View {
    let position: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
            Rectangle()
                .fill(Color.red)
                .frame(height: 1)
        }
        .offset(y: position)
    }
}

#Preview {
    TimelineView()
        .environmentObject(TaskViewModel())
} 
