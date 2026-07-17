import Foundation
import SwiftUI
import Combine

enum QuizState {
    case loading
    case loaded([TriviaQuestion])
    case failed
}

@MainActor
class QuizRushVM: ObservableObject {
    @Published var state: QuizState = .loading
    @Published var currentIndex = 0
    @Published var score = 0
    @Published var streak = 0
    @Published var isGameOver = false
    @Published var shuffledAnswers: [String] = []
    
    private let api = TriviaAPI()
    
    func loadQuestions() async {
        state = .loading
        isGameOver = false
        score = 0
        streak = 0
        currentIndex = 0
        
        do {
            let questions = try await api.fetchQuestions()
            state = .loaded(questions)
            prepareAnswers(for: questions[0])
        } catch {
            state = .failed
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
