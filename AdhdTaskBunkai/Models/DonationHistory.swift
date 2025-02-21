import Foundation

struct DonationHistory: Identifiable, Codable {
    let id: UUID
    let points: Int
    let yenAmount: Double
    let timestamp: Date
    let organization: String
    let impact: String
    
    init(points: Int, organization: String, impact: String) {
        self.id = UUID()
        self.points = points
        self.yenAmount = Double(points) * Constants.Points.pointToYenRate
        self.timestamp = Date()
        self.organization = organization
        self.impact = impact
    }
}

struct Organization: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let imageURL: URL?
    let websiteURL: URL?
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        imageURL: URL? = nil,
        websiteURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.websiteURL = websiteURL
    }
}

// MARK: - Mock Data
extension Organization {
    static let mockOrganizations = [
        Organization(
            name: "発達障害支援センター",
            description: "発達障害のある子どもたちとその家族をサポートする活動を行っています。",
            imageURL: URL(string: "https://example.com/org1.jpg"),
            websiteURL: URL(string: "https://example.com/org1")
        ),
        Organization(
            name: "学習支援ネットワーク",
            description: "発達障害のある子どもたちへの学習支援と居場所づくりを提供しています。",
            imageURL: URL(string: "https://example.com/org2.jpg"),
            websiteURL: URL(string: "https://example.com/org2")
        ),
        Organization(
            name: "就労支援プロジェクト",
            description: "発達障害のある方々の就労支援と職場での理解促進を行っています。",
            imageURL: URL(string: "https://example.com/org3.jpg"),
            websiteURL: URL(string: "https://example.com/org3")
        )
    ]
}

extension DonationHistory {
    static let mockDonationHistory = [
        DonationHistory(
            points: 100,
            organization: "発達障害支援センター",
            impact: "3回分の学習支援プログラムの提供に貢献"
        ),
        DonationHistory(
            points: 50,
            organization: "学習支援ネットワーク",
            impact: "1人分の教材提供に貢献"
        ),
        DonationHistory(
            points: 200,
            organization: "就労支援プロジェクト",
            impact: "1回分の就労支援セミナーの開催に貢献"
        )
    ]
} 
