import SwiftUI

struct HomeTab: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("PlayHub Launcher")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                Text("Select a game mode to test your speed, alertness, or intelligence.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                NavigationLink(destination: TapFrenzyView()) {
                    HomeMenuRow(title: "Tap Frenzy", subtitle: "Tap as fast as you can!", systemImage: "hand.tap.fill", color: .indigo)
                }
                
                NavigationLink(destination: LightItUpView()) {
                    HomeMenuRow(title: "Light It Up", subtitle: "Test your spatial reaction times", systemImage: "square.grid.3x3.topleft.filled", color: .teal)
                }
                
                NavigationLink(destination: QuizRushView()) {
                    HomeMenuRow(title: "Quiz Rush", subtitle: "Live API Trivia engine battle", systemImage: "questionmark.bubble.fill", color: .purple)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
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
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
