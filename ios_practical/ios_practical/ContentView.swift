import SwiftUI
import Combine
struct ContentView: View {
    // MARK: - State Variables
    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var isGameOver = false
    
    // @AppStorage automatically saves the high score to UserDefaults
    @AppStorage("highScore") private var highScore = 0
    
    // The 1-second countdown timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Background styling
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            // View Swapping based on game state
            if isGameOver {
                gameOverScreen
            } else {
                gameScreen
            }
        }
    }
    
    // MARK: - Active Game View
    var gameScreen: some View {
        VStack(spacing: 40) {
            
            // Top Bar: Timer and Score
            HStack {
                Text("Time: \(timeRemaining)")
                    .foregroundColor(timeRemaining <= 3 ? .red : .primary)
                Spacer()
                Text("Score: \(score)")
            }
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            Spacer()
            
            // Central TAP Button
            Button(action: {
                if timeRemaining > 0 {
                    score += 1
                }
            }) {
                Text("TAP")
                    .font(.system(size: 60, weight: .black, design: .rounded))
                    .frame(width: 220, height: 220)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 10)
            }
            .disabled(timeRemaining == 0) // Disables tap when time is up
            
            Spacer()
        }
        // Timer Logic
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else if timeRemaining == 0 && !isGameOver {
                endGame()
            }
        }
    }
    
    // MARK: - Game Over View
    var gameOverScreen: some View {
        VStack(spacing: 30) {
            Text("GAME OVER")
                .font(.system(size: 45, weight: .heavy, design: .rounded))
                .foregroundColor(.red)
            
            VStack(spacing: 10) {
                Text("Final Score")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("\(score)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
            }
            
            // High Score Detection Logic
            if score > highScore && score > 0 {
                Text("🎉 NEW HIGH SCORE! 🎉")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding(.top, 10)
            } else {
                Text("High Score: \(highScore)")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
            
            Spacer().frame(height: 40)
            
            // Play Again Button
            Button(action: resetGame) {
                Text("Play Again")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: 250)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
        }
    }
    
    // MARK: - Game Logic Functions
    func endGame() {
        isGameOver = true
        // Save high score if the current score beats it
        if score > highScore {
            highScore = score
        }
    }
    
    func resetGame() {
        score = 0
        timeRemaining = 10
        isGameOver = false
    }
}

#Preview {
    ContentView()
}
