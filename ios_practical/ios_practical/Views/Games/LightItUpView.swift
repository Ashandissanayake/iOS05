import SwiftUI
import CoreLocation

struct LightItUpView: View {
    @StateObject private var viewModel = LightItUpVM()
    @EnvironmentObject var statsVM: StatsVM
    @EnvironmentObject var locationService: LocationService
    @AppStorage("light_it_up_high") var highScore = 0
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Score: \(viewModel.score)").font(.title2).bold()
                Spacer()
                Text("Level: \(String(describing: viewModel.currentLevel).uppercased())")
                    .foregroundColor(viewModel.currentLevel.glowColor).bold()
                Spacer()
                HStack {
                    ForEach(0..<3) { item in
                        Image(systemName: item < viewModel.lives ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            
            Text("Timer Remaining: \(viewModel.timeRemaining)s")
                .font(.headline)
            
            Spacer()
            
            LazyVGrid(columns: viewModel.currentLevel.columns, spacing: 15) {
                ForEach(Array(viewModel.cards.enumerated()), id: \.element.id) { _, card in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(card.isLit ? viewModel.currentLevel.glowColor : Color(.systemGray5))
                        .frame(height: 100)
                        .scaleEffect(card.isLit ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: card.isLit)
                        .shadow(color: card.isLit ? viewModel.currentLevel.glowColor.opacity(0.6) : .clear, radius: 10)
                        .onTapGesture {
                            viewModel.handleCardTap(card)
                        }
                }
            }
            .padding()
            
            Spacer()
        }
        .onAppear {
            viewModel.startGame()
        }
        .sheet(isPresented: $viewModel.isGameOver) {
            ResultView(
                mode: .lightItUp,
                score: viewModel.score,
                isNewHigh: viewModel.score > highScore,
                onPlayAgain: { viewModel.startGame() }
            )
            .onAppear {
                if viewModel.score > highScore { highScore = viewModel.score }
                let coord = locationService.snapshotCoordinate()
                statsVM.saveSession(mode: .lightItUp, score: viewModel.score, lat: coord.latitude, lon: coord.longitude)
            }
        }
    }
}
