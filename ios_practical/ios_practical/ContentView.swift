import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @AppStorage("highScore") private var highScore = 0
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            if viewModel.isGameOver {
                gameOverScreen
            } else {
                gameScreen
            }
        }
        .onChange(of: viewModel.isGameOver) { _, isOver in
            if isOver && viewModel.score > highScore {
                highScore = viewModel.score
            }
        }
    }
    
    var gameScreen: some View {
        VStack(spacing: 40) {
            HStack {
                Text("Time: \(viewModel.timeRemaining)")
                    .foregroundColor(viewModel.timeRemaining <= 3 ? .red : .primary)
                Spacer()
                Text("Score: \(viewModel.score)")
            }
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            Spacer()
            
            Button(action: {
                viewModel.handleTap()
            }) {
                Text("TAP")
                    .font(.system(size: 60, weight: .black, design: .rounded))
                    .frame(width: 220, height: 220)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 10)
            }
            .disabled(viewModel.timeRemaining == 0)
            
            Spacer()
        }
    }
    
    var gameOverScreen: some View {
        VStack(spacing: 30) {
            Text("GAME OVER")
                .font(.system(size: 45, weight: .heavy, design: .rounded))
                .foregroundColor(.red)
            
            VStack(spacing: 10) {
                Text("Final Score")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("\(viewModel.score)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
            }
            
            if viewModel.score > highScore && viewModel.score > 0 {
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
            
            Button(action: viewModel.resetGame) {
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
}

#Preview {
    ContentView()
}
