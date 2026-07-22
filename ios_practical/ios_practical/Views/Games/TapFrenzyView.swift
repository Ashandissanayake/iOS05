import SwiftUI
import CoreLocation

struct TapFrenzyView: View {
    @StateObject private var viewModel = TapFrenzyVM()
    @EnvironmentObject var statsVM: StatsVM
    @EnvironmentObject var locationService: LocationService
    @Environment(\.dismiss) var dismiss
    @AppStorage("tap_frenzy_high") var highScore = 0
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Score: \(viewModel.score)")
                    .font(.title)
                    .bold()
                Spacer()
                Text("High Score: \(highScore)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.top)
            
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
                } else if viewModel.trapState == .bonus {
                    Text("💚 GREEN TRAP: BONUS POINTS")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.green)
                } else if viewModel.trapState == .penalty {
                    Text("⚠️ GREY TRAP: PENALTY")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.gray)
                }
            }
            
            GeometryReader { geo in
                let buttonSize: CGFloat = viewModel.timeRemaining <= 3 ? 140 : 200
                
                Button(action: {
                    viewModel.handleTap()
                }) {
                    Circle()
                        .fill(viewModel.buttonColor)
                        .frame(width: buttonSize, height: buttonSize)
                        .overlay(
                            Text(viewModel.buttonLabel)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                        )
                        .shadow(radius: 10)
                }
                .disabled(viewModel.isGameOver || viewModel.timeRemaining == 0)
                .position(
                    x: geo.size.width * viewModel.targetPosition.x,
                    y: geo.size.height * viewModel.targetPosition.y
                )
            }
            .padding(.bottom)
        }
        .onAppear {
            viewModel.startGame()
        }
        .sheet(isPresented: $viewModel.isGameOver) {
            ResultView(
                mode: .tapFrenzy,
                score: viewModel.score,
                isNewHigh: viewModel.score > highScore,
                onPlayAgain: {
                    viewModel.startGame()
                },
                onExit: {
                    viewModel.isGameOver = false
                    dismiss()
                }
            )
            .onAppear {
                if viewModel.score > highScore {
                    highScore = viewModel.score
                }
                
                // Get the coordinate from your location service
                let coord = locationService.snapshotCoordinate()
                
                statsVM.saveSession(
                    mode: .tapFrenzy,
                    score: viewModel.score,
                    lat: coord.latitude,
                    lon: coord.longitude
                )
            }
        }
    }
}
