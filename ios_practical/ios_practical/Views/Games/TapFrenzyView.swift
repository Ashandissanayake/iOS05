import SwiftUI
import CoreLocation

struct TapFrenzyView: View {
    @StateObject private var viewModel = TapFrenzyVM()
    @EnvironmentObject var statsVM: StatsVM
    @EnvironmentObject var locationService: LocationService
    @AppStorage("tap_frenzy_high") var highScore = 0
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Text("Score: \(viewModel.score)")
                    .font(.title)
                    .bold()
                Spacer()
                Text("High Score: \(highScore)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            
            Text("\(viewModel.timeRemaining)s")
                .font(.system(size: 60, weight: .heavy, design: .monospaced))
                .foregroundColor(viewModel.timeRemaining <= 3 ? .red : .primary)
            
            HStack {
                Text("Multiplier: x\(viewModel.multiplier)")
                    .font(.headline)
                    .foregroundColor(.indigo)
                if viewModel.isBurstActive {
                    Text("🔥 BURST ACTIVE MODE: DOUBLE POINTS")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.orange)
                }
            }
            
            // Moving Target: button roams the play area, repositioned every 2s by the VM
            GeometryReader { geo in
                Button(action: {
                    viewModel.handleTap()
                }) {
                    Circle()
                        .fill(viewModel.isBurstActive ? Color.orange : Color.indigo)
                        .frame(width: buttonSize, height: buttonSize)
                        .overlay(
                            Text("TAP NOW")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                        )
                        .shadow(radius: 10)
                }
                .disabled(viewModel.isGameOver || viewModel.timeRemaining == 0)
                .position(
                    x: viewModel.targetPosition.x * geo.size.width,
                    y: viewModel.targetPosition.y * geo.size.height
                )
            }
        }
        .onAppear {
            viewModel.startGame()
        }
        .sheet(isPresented: $viewModel.isGameOver) {
            ResultView(
                mode: .tapFrenzy,
                score: viewModel.score,
                isNewHigh: viewModel.score > highScore,
                restartAction: { viewModel.startGame() }
            )
            .onAppear {
                if viewModel.score > highScore { highScore = viewModel.score }
                let lat = locationService.lastLocation?.coordinate.latitude ?? 6.9271
                let lon = locationService.lastLocation?.coordinate.longitude ?? 79.8612
                statsVM.saveSession(mode: .tapFrenzy, score: viewModel.score, lat: lat, lon: lon)
            }
        }
    }
    
    private var buttonSize: CGFloat {
        viewModel.timeRemaining <= 3 ? 140 : 200
    }
}
