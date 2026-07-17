import Foundation

struct TriviaResponse: Codable {
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Codable, Identifiable {
    var id: UUID { UUID() }
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case category, type, difficulty, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
    
    // Helper to get all answers shuffled
    var allAnswers: [String] {
        var answers = incorrectAnswers
        answers.append(correctAnswer)
        return answers.shuffled()
    }
}
