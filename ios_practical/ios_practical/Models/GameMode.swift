import Foundation

enum GameMode: String, Codable, CaseIterable, Identifiable {
    case tapFrenzy = "Tap Frenzy"
    case lightItUp = "Light It Up"
    case quizRush = "Quiz Rush"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .tapFrenzy: return "bolt.fill"
        case .lightItUp: return "lightbulb.fill"
        case .quizRush: return "questionmark.circle.fill"
        }
    }
}
