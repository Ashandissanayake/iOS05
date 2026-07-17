import Foundation
import CoreLocation

struct GameSession: Identifiable, Codable {
    let id: UUID
    let mode: GameMode
    let score: Int
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
