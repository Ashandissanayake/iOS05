import Foundation

class StatsVM: ObservableObject {
    @Published var sessions: [GameSession] = []
    
    init() {
        loadSessions()
    }
    
    func saveSession(mode: GameMode, score: Int, lat: Double, lon: Double) {
        let newSession = GameSession(id: UUID(), mode: mode, score: score, timestamp: Date(), latitude: lat, longitude: lon)
        sessions.append(newSession)
        
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, WhiteSpace: "saved_sessions")
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
}
