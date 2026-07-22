import SwiftUI

struct ScoreBadge: View {
    let mode: GameMode
    let score: Int
    let isNewHigh: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Label(mode.rawValue, systemImage: mode.iconName)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("\(score)")
                .font(.system(size: 70, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
            
            if isNewHigh {
                Text("🎉 NEW HIGH SCORE!")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ScoreBadge(mode: .tapFrenzy, score: 42, isNewHigh: true)
        .padding()
        .background(Color(red: 0.15, green: 0.17, blue: 0.22))
}
