import Foundation
import Combine

@MainActor
class ContentViewModel: ObservableObject {
    @Published var score = 0
    @Published var timeRemaining = 10
    @Published var isGameOver = false
    
    private var timerCancellable: AnyCancellable?
    
    init() {
        startTimer()
    }
    
    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    private func tick() {
        guard !isGameOver else { return }
        if timeRemaining > 0 {
            timeRemaining -= 1
            if timeRemaining == 0 {
                endGame()
            }
        }
    }
    
    func handleTap() {
        guard timeRemaining > 0 else { return }
        score += 1
    }
    
    func endGame() {
        isGameOver = true
    }
    
    func resetGame() {
        score = 0
        timeRemaining = 10
        isGameOver = false
    }
}
