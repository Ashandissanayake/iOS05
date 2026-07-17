import SwiftUI

struct LightItUpView: View {
    @StateObject private var viewModel = LightItUpVM()
    @EnvironmentObject var statsVM: StatsVM
    @EnvironmentObject var locationService: LocationService
    @AppStorage("light_it_up_high") var highScore = 0
    
    var columns: [GridItem] {
        switch viewModel.currentLevel {
        case .l1: return Array(repeating: GridItem(.flexible()), count: 3)
        case .l2: return Array(repeating: GridItem(.flexible()), count: 2)
        case .l3: return Array(repeating: GridItem(.flexible()), count: 3)
        case .l4: return Array(repeating: GridItem(.flexible()), count: 3)
        }
    }
    
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
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(0..<viewModel.currentLevel.gridCount, id: \.self) { idx in
                    let isLit = viewModel.litIndices.contains(idx)
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isLit ? viewModel.currentLevel.glowColor : Color(.systemGray5))
                        .frame(height: 100)
                        .scaleEffect(isLit ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: isLit)
                        .shadow(color: isLit ? viewModel.currentLevel.glowColor.opacity(0.6) : .clear, radius: 10)
                        .onTapGesture {
                            viewModel.handleCardTap(index: idx)
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
                restartAction: { viewModel.startGame() }
            )
            .onAppear {
                if viewModel.score > highScore { highScore = viewModel.score }
                let lat = locationService.lastLocation?.coordinate.latitude ?? 6.9271
                let lon = locationService.lastLocation?.coordinate.longitude ?? 79.8612
                statsVM.saveSession(mode: .lightItUp, score: viewModel.score, lat: lat, lon: lon)
            }
        }
    }
}
