import SwiftUI

struct HomeTab: View {
    @EnvironmentObject var statsVM: StatsVM
    @EnvironmentObject var locationService: LocationService
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.24, green: 0.12, blue: 0.48),
                        Color(red: 0.05, green: 0.02, blue: 0.15),
                        .black
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.pink, .purple, .cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .padding(.top, 24)
                        
                        Text("Game Center")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            ScoreBadgeView(title: "Tap", score: statsVM.personalBest(for: .tapFrenzy))
                            ScoreBadgeView(title: "Light", score: statsVM.personalBest(for: .lightItUp))
                            ScoreBadgeView(title: "Quiz", score: statsVM.personalBest(for: .quizRush))
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            NavigationLink(destination: TapFrenzyView()) {
                                HomeMenuRow(title: "Tap Frenzy", subtitle: "Tap as fast as you can!", systemImage: "hand.tap.fill", color: .indigo)
                            }
                            
                            NavigationLink(destination: LightItUpView()) {
                                HomeMenuRow(title: "Light It Up", subtitle: "Test your spatial reaction times", systemImage: "square.grid.3x3.topleft.filled", color: .teal)
                            }
                            
                            NavigationLink(destination: QuizRushView()) {
                                HomeMenuRow(title: "Quiz Rush", subtitle: "10 quick trivia questions", systemImage: "questionmark.bubble.fill", color: .purple)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            locationService.requestPermission()
        }
    }
}

private struct ScoreBadgeView: View {
    let title: String
    let score: Int
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
            Text("\(score)")
                .font(.title3)
                .bold()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.08))
        .cornerRadius(16)
    }
}

struct HomeMenuRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: systemImage)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.4))
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
