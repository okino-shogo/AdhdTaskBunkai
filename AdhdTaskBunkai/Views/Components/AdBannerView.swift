import SwiftUI

struct BannerView: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(height: 50)
            .overlay(
                Text("広告スペース")
                    .foregroundColor(.gray)
            )
    }
}

struct BannerContainer: View {
    var body: some View {
        BannerView()
    }
}

#Preview {
    BannerContainer()
} 
