import SwiftUI

struct HomeTab: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                Text("Arcade Hub")
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(.white)
                
                VStack(spacing: 20) {
                    // Push Tap Frenzy Game View
                    NavigationLink(destination: Text("Tap Frenzy Game View Layer Go Here")) {
                        GameMenuButton(title: "🔥 TAP FRENZY", subtitle: "Tap as fast as you can!", baseColor: .orange)
                    }
                    
                    // Push New Light It Up Game View
                    NavigationLink(destination: LightItUpView()) {
                        GameMenuButton(title: "💡 LIGHT IT UP", subtitle: "Catch the glowing grid cards!", baseColor: .blue)
                    }
                }
                .padding(.horizontal, 25)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.1, green: 0.12, blue: 0.16).ignoresSafeArea())
        }
    }
}

struct GameMenuButton: View {
    let title: String
    let subtitle: String
    let baseColor: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title2).bold()
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
        }
        .padding(24)
        .background(baseColor.gradient)
        .cornerRadius(16)
        .shadow(color: baseColor.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}
