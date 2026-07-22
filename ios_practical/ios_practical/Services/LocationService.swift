import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        manager.startUpdatingLocation()
    }
    
    /// Returns the best-known location right now, falling back to (0,0) if unavailable.
    /// Used at the moment a game session ends so we always have coordinates to record.
    func snapshotCoordinate() -> (latitude: Double, longitude: Double) {
        if let loc = currentLocation {
            return (loc.latitude, loc.longitude)
        }
        return (0, 0)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
}
