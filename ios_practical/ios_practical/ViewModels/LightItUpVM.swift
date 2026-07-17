import SwiftUI
import Combine

class LightItUpVM: ObservableObject {
    // Game States
    @Published var cards: [LightUpCard] = []
    @Published var currentLevel: LightUpLevel = .L1
    @Published var score: Int = 0
    @Published var lives: Int = 3
    @Published var timeRemaining: TimeInterval = 60.0
    @Published var isPlaying: Bool = false
    @Published var isGameOver: Bool = false
    @Published var showLevelUpFlash: Bool = false
    
    // Configurable round length (bound to Settings)
    private var totalRoundLength: TimeInterval = 60.0
    
    // Core Timers
    private var gameTimer: AnyCancellable?
    private var tickTimer: AnyCancellable?
    private var elapsedSeconds: TimeInterval = 0
    
    // High Score Persistence
    @AppStorage("lightitup_highscore") var highScore: Int = 0
    
    func startGame(roundLength: TimeInterval = 60.0) {
        self.totalRoundLength = roundLength
        self.timeRemaining = roundLength
        self.score = 0
        self.lives = 3
        self.elapsedSeconds = 0
        self.currentLevel = .L1
        self.isGameOver = false
        self.isPlaying = true
        
        setupLevel(self.currentLevel)
        startTimers()
    }
    
    private func setupLevel(_ level: LightUpLevel) {
        // Build card array for grid size
        self.cards = (0..<level.cardCount).map { LightUpCard(id: $0) }
        triggerNextTick()
    }
    
    private func startTimers() {
        // Main countdown timer
        gameTimer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateCountdown()
            }
    }
    
    private func updateCountdown() {
        guard isPlaying else { return }
        
        elapsedSeconds += 1
        timeRemaining = max(0, totalRoundLength - elapsedSeconds)
        
        if timeRemaining <= 0 {
            endGame()
            return
        }
        
        // Evaluate level progression based on elapsed time
        let correctLevel = LightUpLevel.allCases.first { $0.durationRange.contains(elapsedSeconds) } ?? .L4
        if correctLevel != currentLevel {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.currentLevel = correctLevel
                self.showLevelUpFlash = true
                self.setupLevel(correctLevel)
            }
            
            // Auto dismissal of level-up notification overlay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation { self.showLevelUpFlash = false }
            }
        }
    }
    
    private func triggerNextTick() {
        tickTimer?.cancel()
        
        // Dim all active cards on rotation tick
        for i in 0..<cards.count {
            cards[i].isLit = false
        }
        
        // Pick new random indices to light up based on level configuration
        let activeCount = min(currentLevel.concurrentLitCards, cards.count)
        var indicesToLight = Set<Int>()
        
        while indicesToLight.count < activeCount && indicesToLight.count < cards.count {
            let randomIndex = Int.random(in: 0..<cards.count)
            indicesToLight.insert(randomIndex)
        }
        
        for index in indicesToLight {
            cards[index].isLit = true
        }
        
        // Re-publish tick according to current window length
        tickTimer = Timer.publish(every: currentLevel.litDuration, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.handleMissedTick()
            }
    }
    
    private func handleMissedTick() {
        guard isPlaying else { return }
        
        // Deduct a life if a lit card wasn't tapped before window timed out
        let missedAny = cards.contains { $0.isLit }
        if missedAny {
            reduceLife()
        }
        
        // Game may have just ended inside reduceLife() — don't restart the tick loop
        guard isPlaying else { return }
        triggerNextTick()
    }
    
    func handleCardTap(_ card: LightUpCard) {
        guard isPlaying, let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        if cards[index].isLit {
            // Correct hit
            score += 10
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                cards[index].isLit = false
            }
            
            // Check if all current active cards are cleared early
            if !cards.contains(where: { $0.isLit }) {
                triggerNextTick()
            }
        } else {
            // Incorrect click penalty
            reduceLife()
        }
    }
    
    private func reduceLife() {
        withAnimation(.default) {
            lives -= 1
        }
        if lives <= 0 {
            endGame()
        }
    }
    
    func endGame() {
        isPlaying = false
        isGameOver = true
        gameTimer?.cancel()
        tickTimer?.cancel()
        
        if score > highScore {
            highScore = score
        }
    }
}
