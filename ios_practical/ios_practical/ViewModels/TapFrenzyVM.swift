import Foundation
import SwiftUI

class TapFrenzyVM: ObservableObject {
    @Published var score = 0
    @Published var timeRemaining = 10
    @Published var isGameOver = false
    @Published var multiplier = 1
    @Published var isBurstActive = false
    
    private var timer: Timer?
    private var lastTapTime = Date.distantPast
    private var burstTimer: Timer?
    
    func startGame() {
        score = 0
        timeRemaining = 10
        multiplier = 1
        isGameOver = false
        isBurstActive = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                
                // Randomly trigger Burst challenge (2-second double points window)
                if self.timeRemaining == 6 {
                    self.triggerBurst()
                }
            } else {
                self.endGame()
            }
        }
    }
    
    func handleTap() {
        guard !isGameOver else { return }
        
        let now = Date()
        // Challenge 1: Combo System (Taps within 0.5s increment multiplier)
        if now.timeIntervalSince(lastTapTime) <= 0.5 {
            if multiplier < 5 { multiplier += 1 }
        } else {
            multiplier = 1
        }
        lastTapTime = now
        
        // Challenge 5: Burst (Double points logic)
        let pointsToAdd = multiplier * (isBurstActive ? 2 : 1)
        score += pointsToAdd
    }
    
    private func triggerBurst() {
        withAnimation { isBurstActive = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation { self.isBurstActive = false }
        }
    }
    
    private func endGame() {
        timer?.invalidate()
        isGameOver = true
    }
}
