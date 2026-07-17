import Foundation
import SwiftUI
import Combine

enum GameLevel: Equatable {
    case l1, l2, l3, l4
    
    var gridCount: Int {
        switch self {
        case .l1: return 3
        case .l2: return 4
        case .l3: return 6
        case .l4: return 9
        }
    }
    
    var activeCount: Int {
        switch self {
        case .l1, .l2, .l3: return 1
        case .l4: return 2
        }
    }
    
    var interval: TimeInterval {
        switch self {
        case .l1: return 1.5
        case .l2: return 1.2
        case .l3: return 1.0
        case .l4: return 0.8
        }
    }
    
    var glowColor: Color {
        switch self {
        case .l1: return .green
        case .l2: return .blue
        case .l3: return .orange
        case .l4: return .purple
        }
    }
}

class LightItUpVM: ObservableObject {
    @Published var score = 0
    @Published var lives = 3
    @Published var timeRemaining = 60
    @Published var isGameOver = false
    @Published var currentLevel: GameLevel = .l1
    @Published var litIndices: Set<Int> = []
    
    private var gameTimer: Timer?
    private var tickTimer: Timer?
    
    func startGame() {
        score = 0
        lives = 3
        timeRemaining = 60
        currentLevel = .l1
        isGameOver = false
        
        setupTimers()
        generateLitCards()
    }
    
    private func setupTimers() {
        gameTimer?.invalidate()
        tickTimer?.invalidate()
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.updateLevelProgression()
            } else {
                self.endGame()
            }
        }
        
        startTickTimer()
    }
    
    private func startTickTimer() {
        tickTimer?.invalidate()
        tickTimer = Timer.scheduledTimer(withTimeInterval: currentLevel.interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.generateLitCards()
        }
    }
    
    private func updateLevelProgression() {
        let elapsed = 60 - timeRemaining
        var nextLevel = GameLevel.l1
        if elapsed > 45 { nextLevel = .l4 }
        else if elapsed > 30 { nextLevel = .l3 }
        else if elapsed > 15 { nextLevel = .l2 }
        
        if nextLevel != currentLevel {
            currentLevel = nextLevel
            startTickTimer()
        }
    }
    
    func generateLitCards() {
        litIndices.removeAll()
        let count = currentLevel.gridCount
        let target = currentLevel.activeCount
        
        while litIndices.count < target {
            let randomIndex = Int.random(in: 0..<count)
            litIndices.insert(randomIndex)
        }
    }
    
    func handleCardTap(index: Int) {
        guard !isGameOver else { return }
        
        if litIndices.contains(index) {
            score += 10
            litIndices.remove(index)
            if litIndices.isEmpty { generateLitCards() }
        } else {
            // Apply Penalty: 3 Lives System implemented instead of standard point loss
            lives -= 1
            if lives <= 0 {
                endGame()
            }
        }
    }
    
    private func endGame() {
        gameTimer?.invalidate()
        tickTimer?.invalidate()
        isGameOver = true
    }
}
