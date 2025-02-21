import Foundation

enum Constants {
    enum API {
        static let openAIKey = "YOUR_OPENAI_API_KEY"
        static let googleMapsKey = "YOUR_GOOGLE_MAPS_API_KEY"
        static let admobKey = "ca-app-pub-3940256099942544/2934735716"
    }
    
    enum Points {
        static let taskCompletionPoints = 10
        static let pointToYenRate = 0.3
    }
    
    enum UI {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let spacing: CGFloat = 8
    }
    
    enum Notification {
        static let defaultReminderTime = 10 // minutes
        static let travelReminderTime = 5 // minutes
    }
} 
