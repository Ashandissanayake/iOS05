import SwiftUI

struct HomeTab: View {
    @EnvironmentObject var statsVM: StatsVM
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.08, blue: 0.12)
                    .ignoresSafeArea()
                
                VStack(spacing: 28) {
                    // Glowing header icon
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.purple.opacity(0.6), Color.pink.opacity(0.3), .clear],
                                    center: .center, startRadius: 5, endRadius: 90
                                )
                            )
                            .frame(width: 160, height: 160)
                            .blur(radius: 10)
                        
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(
                                LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                    }
                    .padding(.top, 20)
                    
                    Text("Game Center")
                        .font(.system(size: 34, weight: .black))
                        .foregroundColor(.white)
                    
                    // Personal Best row
                    HStack(spacing: 12) {
                        ForEach(GameMode.allCases) { mode in
                            PersonalBestBadge(
                                label: shortLabel(for: mode),
                                score: statsVM.personalBest(for: mode)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Menu rows
                    VStack(spacing: 16) {
                        NavigationLink(destination: TapFrenzyView()) {
                            GameMenuRow(mode: .tapFrenzy)
                        }
                        NavigationLink(destination: LightItUpView()) {
                            GameMenuRow(mode: .lightItUp)
                        }
                        NavigationLink(destination: QuizRushView()) {
                            GameMenuRow(mode: .quizRush)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
        }
    }
    
    private func shortLabel(for mode: GameMode) -> String {
        switch mode {
        case .tapFrenzy: return "Tap"
        case .lightItUp: return "Light"
        case .quizRush: return "Quiz"
        }
    }
}

// MARK: - Personal Best badge
struct PersonalBestBadge: View {
    let label: String
    let score: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            Text("\(score)")
                .font(.title3).bold()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.08))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Game menu row
struct GameMenuRow: View {
    let mode: GameMode
    
    private var accentColor: Color {
        switch mode {
        case .tapFrenzy: return .orange
        case .lightItUp: return .pink
        case .quizRush: return .cyan
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: mode.iconName)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(accentColor.opacity(0.3))
                .clipShape(Circle())
            
            Text(mode.rawValue)
                .font(.title3).bold()
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right.circle.fill")
                .font(.system(size: 22))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(Color.white.opacity(0.06))
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(accentColor.opacity(0.6), lineWidth: 1.5)
        )
    }
}

#Preview {
    HomeTab()
        .environmentObject(StatsVM())
}
