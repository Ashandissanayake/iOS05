import Foundation

enum GameMode: String, Codable, CaseIterable, Identifiable {
    case tapFrenzy = "Tap Frenzy"
    case lightItUp = "Light It Up"
    case quizRush = "Quiz Rush"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .tapFrenzy: return "hand.tap.fill"
        case .lightItUp: return "square.grid.3x3.topleft.filled"
        case .quizRush: return "questionmark.bubble.fill"
        }
    }
}
