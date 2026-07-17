import Foundation
import SwiftUI
import Combine

enum TrapState: Equatable {
    case normal, bonus, penalty
}

class TapFrenzyVM: ObservableObject {
    @Published var score = 0
    @Published var timeRemaining = 10
    @Published var isGameOver = false
    @Published var multiplier = 1
    @Published var isBurstActive = false
    @Published var trapState: TrapState = .normal
    @Published var targetPosition = CGPoint(x: 0.5, y: 0.5)
    
    private var timer: Timer?
    private var lastTapTime = Date.distantPast
    private var trapTimer: Timer?
    private var moveTimer: Timer?
    
    var buttonColor: Color {
        if isBurstActive { return .orange }
        switch trapState {
        case .normal: return .indigo
        case .bonus: return .green
        case .penalty: return .gray
        }
    }
    
    var buttonLabel: String {
        if isBurstActive { return "BURST!" }
        switch trapState {
        case .normal: return "TAP NOW"
        case .bonus: return "BONUS!"
        case .penalty: return "TRAP!"
        }
    }
    
    func startGame() {
        score = 0
        timeRemaining = 10
        multiplier = 1
        isGameOver = false
        isBurstActive = false
        trapState = .normal
        targetPosition = CGPoint(x: 0.5, y: 0.5)
        
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
        
        startTrapTimer()
        startMoveTimer()
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
        
        let basePoints = multiplier * (isBurstActive ? 2 : 1)
        
        // Challenge 2: Trap Colour (green = bonus, grey = penalty)
        switch trapState {
        case .bonus:
            score += basePoints * 2
        case .penalty:
            score = max(0, score - basePoints)
        case .normal:
            score += basePoints
        }
    }
    
    // Challenge 5: Burst (Double points logic)
    private func triggerBurst() {
        withAnimation { isBurstActive = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation { self.isBurstActive = false }
        }
    }
    
    // Challenge 2: Trap Colour — button cycles colour every couple of seconds
    private func startTrapTimer() {
        trapTimer?.invalidate()
        trapTimer = Timer.scheduledTimer(withTimeInterval: 2.2, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let roll = Int.random(in: 0..<10)
            withAnimation {
                if roll < 6 {
                    self.trapState = .normal
                } else if roll < 8 {
                    self.trapState = .bonus
                } else {
                    self.trapState = .penalty
                }
            }
        }
    }
    
    // Challenge 3: Moving Target — button jumps to a random position every 2 seconds
    private func startMoveTimer() {
        moveTimer?.invalidate()
        moveTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            withAnimation(.easeInOut(duration: 0.4)) {
                self.targetPosition = CGPoint(
                    x: Double.random(in: 0.2...0.8),
                    y: Double.random(in: 0.2...0.8)
                )
            }
        }
    }
    
    private func endGame() {
        timer?.invalidate()
        trapTimer?.invalidate()
        moveTimer?.invalidate()
        isGameOver = true
    }
}
