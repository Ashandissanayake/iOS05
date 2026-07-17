import SwiftUI

struct LightItUpView: View {
    @StateObject private var viewModel = LightItUpVM()
    @AppStorage("round_duration_setting") private var roundDuration: Double = 60.0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZCombineView {
            Color(red: 0.1, green: 0.12, blue: 0.16)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Info Bar Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Score: \(viewModel.score)")
                            .font(.title2).bold()
                            .foregroundColor(.white)
                        Text("High Score: \(viewModel.highScore)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Level Indicator with unique colors
                    Text("LEVEL \(viewModel.currentLevel.rawValue)")
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(viewModel.currentLevel.glowColor.opacity(0.2))
                        .foregroundColor(viewModel.currentLevel.glowColor)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    // Time Left View
                    Text(String(format: "%.1fs", viewModel.timeRemaining))
                        .font(.title2).monospacedDigit().bold()
                        .foregroundColor(viewModel.timeRemaining < 10 ? .red : .white)
                }
                .padding(.horizontal)
                
                // Lives Tracking (3 Lives System)
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Image(systemName: index < viewModel.lives ? "heart.fill" : "heart")
                            .font(.title3)
                            .foregroundColor(index < viewModel.lives ? .red : .gray.opacity(0.4))
                    }
                }
                
                Spacer()
                
                // Dynamic Whack-a-Mole Grid Section
                if viewModel.isPlaying {
                    LazyVGrid(columns: viewModel.currentLevel.columns, spacing: 16) {
                        ForEach(viewModel.cards) { card in
                            CardCell(card: card, glowColor: viewModel.currentLevel.glowColor) {
                                viewModel.handleCardTap(card)
                            }
                        }
                    }
                    .padding(24)
                    .transition(.scale.combined(with: .opacity))
                } else if !viewModel.isGameOver {
                    // Initialization / Preparation screen
                    Button(action: {
                        viewModel.startGame(roundLength: roundDuration)
                    }) {
                        Text("START GAME")
                            .font(.headline).bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 200)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                }
                
                Spacer()
            }
            .blur(radius: viewModel.isGameOver ? 3 : 0)
            
            // Level Up Pop-up Notification Banner
            if viewModel.showLevelUpFlash {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack {
                    Text("LEVEL UP!")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundColor(viewModel.currentLevel.glowColor)
                        .shadow(color: viewModel.currentLevel.glowColor, radius: 10)
                    Text("Get Ready...")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
            
            // Custom Game Over Sheet
            if viewModel.isGameOver {
                GameOverOverlay(score: viewModel.score, isNewHigh: viewModel.score >= viewModel.highScore) {
                    viewModel.startGame(roundLength: roundDuration)
                } onExit: {
                    dismiss()
                }
            }
        }
        .navigationTitle("Light It Up")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Subview for singular Grid Card elements
struct CardCell: View {
    let card: LightUpCard
    let glowColor: Color
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            RoundedRectangle(cornerRadius: 12)
                .fill(card.isLit ? glowColor : Color(red: 0.18, green: 0.20, blue: 0.25))
                .aspectRatio(0.85, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(card.isLit ? Color.white.opacity(0.6) : Color.clear, lineWidth: 2)
                )
                .scaleEffect(card.isLit ? 1.05 : 1.0)
                .shadow(color: card.isLit ? glowColor.opacity(0.8) : Color.clear, radius: card.isLit ? 15 : 0)
        }
        .buttonStyle(StaticButtonStyle())
    }
}

// Strips out automatic button fading behaviors to support exact click intervals
struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

// Game Over view wrapper
struct GameOverOverlay: View {
    let score: Int
    let isNewHigh: Bool
    var onRetry: () -> Void
    var onExit: () -> Void
    
    var body: some View {
        VStack(spacing: 25) {
            Text("GAME OVER")
                .font(.largeTitle).bold()
                .foregroundColor(.red)
            
            VStack(spacing: 8) {
                Text("Final Score")
                    .font(.headline)
                    .foregroundColor(.gray)
                Text("\(score)")
                    .font(.system(size: 54, weight: .bold))
                    .foregroundColor(.white)
                
                if isNewHigh {
                    Text("🎉 NEW HIGH SCORE 🎉")
                        .font(.caption).bold()
                        .foregroundColor(.yellow)
                        .padding(.vertical, 4)
                }
            }
            
            VStack(spacing: 12) {
                Button(action: onRetry) {
                    Text("Play Again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: onExit) {
                    Text("Exit to Menu")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
            }
            .padding(.horizontal, 30)
        }
        .padding(40)
        .background(Color(red: 0.15, green: 0.17, blue: 0.22))
        .cornerRadius(20)
        .shadow(radius: 20)
        .padding(30)
    }
}

// SwiftUI backward compatibility wrapper for safe stacking layout
struct ZCombineView<Content: View>: View {
    let content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    var body: some View { ZStack { content() } }
}
