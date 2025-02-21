import Foundation
import SwiftUI

class DonationViewModel: ObservableObject {
    @Published var userPoints: Int = 0
    @Published var donationHistory: [DonationHistory] = []
    @Published var organizations: [Organization] = []
    @Published var totalDonationAmount: Double = 0
    @Published var selectedOrganization: Organization?
    @Published var isShowingDonationSheet = false
    
    init() {
        // ダミーデータを読み込む
        self.organizations = Organization.mockOrganizations
        self.donationHistory = DonationHistory.mockDonationHistory
        self.totalDonationAmount = donationHistory.reduce(0) { $0 + $1.yenAmount }
    }
    
    func addPoints(_ points: Int) {
        userPoints += points
    }
    
    func makeDonation(points: Int, organization: String, impact: String) {
        guard points <= userPoints else { return }
        
        let donation = DonationHistory(
            points: points,
            organization: organization,
            impact: impact
        )
        
        userPoints -= points
        donationHistory.append(donation)
        totalDonationAmount += donation.yenAmount
        
        // TODO: サーバーに寄付情報を送信する代わりに、成功メッセージを表示
        print("寄付が完了しました！ \(points)ポイントを\(organization)に寄付しました。")
    }
    
    func fetchOrganizations() {
        // ダミーデータを使用しているため、実際のフェッチは不要
    }
    
    func fetchDonationHistory() {
        // ダミーデータを使用しているため、実際のフェッチは不要
    }
    
    // MARK: - Helper Methods
    func formatYen(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "JPY"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: NSNumber(value: amount)) ?? "¥0"
    }
    
    func calculateImpact(points: Int) -> String {
        // ポイントに応じたインパクトメッセージを生成
        let amount = Double(points) * Constants.Points.pointToYenRate
        if amount >= 1000 {
            return "約\(Int(amount / 1000))回分の学習支援プログラムの提供"
        } else if amount >= 500 {
            return "約\(Int(amount / 500))人分の教材提供"
        } else {
            return "支援活動の一部に貢献"
        }
    }
} 
