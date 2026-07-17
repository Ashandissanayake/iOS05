import Foundation
internal import UIKit

class TriviaAPI {
    func fetchQuestions() async throws -> [TriviaQuestion] {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=10&type=multiple") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // The API returns HTML entities (e.g., &quot;), this decodes cleanly:
        let decodedResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
        return decodedResponse.results.map { question in
            TriviaQuestion(
                category: question.category,
                type: question.type,
                difficulty: question.difficulty,
                question: question.question.htmlDecoded,
                correctAnswer: question.correctAnswer.htmlDecoded,
                incorrectAnswers: question.incorrectAnswers.map { $0.htmlDecoded }
            )
        }
    }
}

// Extension to clean up raw HTML entities returned by Open Trivia DB
extension String {
    var htmlDecoded: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        }
        return self
    }
}
