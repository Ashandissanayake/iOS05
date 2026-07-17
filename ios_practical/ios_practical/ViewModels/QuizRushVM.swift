import Foundation
import SwiftUI

enum QuizState {
    case loading
    case loaded([TriviaQuestion])
    case failed
}

class QuizRushVM: ObservableObject {
    @Published var state: QuizState = .loading
    @Published var currentIndex = 0
    @Published var score = 0
    @Published var streak = 0
    @Published var isGameOver = false
    @Published var shuffledAnswers: [String] = []
    
    private let api = TriviaAPI()
    
    func loadQuestions() async {
        DispatchQueue.main.sync {
            self.state = .loading
            self.isGameOver = false
            self.score = 0
            self.streak = 0
            self.currentIndex = 0
        }
        
        do {
            let questions = try await api.fetchQuestions()
            DispatchQueue.main.async {
                self.state = .loaded(questions)
                self.prepareAnswers(for: questions[0])
            }
        } catch {
            DispatchQueue.main.async {
                self.state = .failed
            }
        }
    }
    
    func prepareAnswers(for question: TriviaQuestion) {
        shuffledAnswers = question.allAnswers
    }
    
    func submitAnswer(_ answer: String, currentQuestions: [TriviaQuestion]) {
        let question = currentQuestions[currentIndex]
        
        if answer == question.correctAnswer {
            streak += 1
            score += 10 + (streak * 2) // Bonus tracking
        } else {
            streak = 0
            score = max(0, score - 5) // Point Penalty logic
        }
        
        if currentIndex < currentQuestions.count - 1 {
            currentIndex += 1
            prepareAnswers(for: currentQuestions[currentIndex])
        } else {
            isGameOver = true
        }
    }
}
