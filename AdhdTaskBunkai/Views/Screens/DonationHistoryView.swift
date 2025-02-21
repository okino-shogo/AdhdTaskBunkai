import SwiftUI

struct DonationHistoryView: View {
    @EnvironmentObject var donationViewModel: DonationViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("現在のポイント")
                                .font(.caption)
                            Text("\(donationViewModel.userPoints) pt")
                                .font(.title)
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("累計寄付金額")
                                .font(.caption)
                            Text(donationViewModel.formatYen(donationViewModel.totalDonationAmount))
                                .font(.title2)
                                .bold()
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("寄付履歴") {
                    ForEach(donationViewModel.donationHistory) { donation in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(donation.organization)
                                    .font(.headline)
                                Spacer()
                                Text("\(donation.points) pt")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(donation.impact)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(donation.timestamp, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("寄付履歴")
            .toolbar {
                Button {
                    donationViewModel.isShowingDonationSheet = true
                } label: {
                    Label("寄付する", systemImage: "heart.fill")
                }
            }
            .sheet(isPresented: $donationViewModel.isShowingDonationSheet) {
                DonationSheetView()
            }
        }
    }
}

struct DonationSheetView: View {
    @EnvironmentObject var donationViewModel: DonationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedPoints: Int = 100
    @State private var selectedOrganization: Organization?
    
    var body: some View {
        NavigationView {
            Form {
                Section("寄付ポイント") {
                    Picker("ポイント", selection: $selectedPoints) {
                        ForEach([50, 100, 200, 500, 1000], id: \.self) { points in
                            Text("\(points) pt")
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Text("寄付金額: \(donationViewModel.formatYen(Double(selectedPoints) * Constants.Points.pointToYenRate))")
                        .foregroundColor(.secondary)
                }
                
                Section("支援団体を選択") {
                    ForEach(donationViewModel.organizations) { org in
                        VStack(alignment: .leading) {
                            Text(org.name)
                                .font(.headline)
                            Text(org.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedOrganization = org
                        }
                        .background(
                            selectedOrganization?.id == org.id ?
                            Color.blue.opacity(0.1) : Color.clear
                        )
                    }
                }
                
                if selectedOrganization != nil {
                    Section("予想される支援効果") {
                        Text(donationViewModel.calculateImpact(points: selectedPoints))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("ポイントを寄付")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("寄付する") {
                        if let org = selectedOrganization {
                            donationViewModel.makeDonation(
                                points: selectedPoints,
                                organization: org.name,
                                impact: donationViewModel.calculateImpact(points: selectedPoints)
                            )
                            dismiss()
                        }
                    }
                    .disabled(selectedOrganization == nil)
                }
            }
        }
    }
} 
