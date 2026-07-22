import Foundation
import Combine

class StatsVM: ObservableObject {
    @Published var sessions: [GameSession] = []
    
    init() {
        loadSessions()
    }
    
    func saveSession(mode: GameMode, score: Int, lat: Double, lon: Double) {
        let newSession = GameSession(id: UUID(), mode: mode, score: score, timestamp: Date(), latitude: lat, longitude: lon)
        sessions.append(newSession)
        
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: "saved_sessions")
        }
    }
    
    func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: "saved_sessions"),
           let decoded = try? JSONDecoder().decode([GameSession].self, from: data) {
            self.sessions = decoded
        }
    }
    
    func clearStats() {
        sessions.removeAll()
        UserDefaults.standard.removeObject(forKey: "saved_sessions")
    }
    
    func personalBest(for mode: GameMode) -> Int {
        sessions.filter { $0.mode == mode }.map { $0.score }.max() ?? 0
    }
    
    // MARK: - Aggregate stats used by StatsTab
    
    var totalGamesPlayedAllModes: Int {
        sessions.count
    }
    
    var averageScoreAllModes: Double {
        guard !sessions.isEmpty else { return 0 }
        return Double(sessions.reduce(0) { $0 + $1.score }) / Double(sessions.count)
    }
    
    func sessions(for mode: GameMode) -> [GameSession] {
        sessions.filter { $0.mode == mode }
    }
    
    var recentSessions: [GameSession] {
        Array(sessions.reversed().prefix(5))
    }
}
