import SwiftUI
import MapKit

struct MapTab: View {
    @EnvironmentObject var statsVM: StatsVM
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        NavigationStack {
            Map(position: $position) {
                ForEach(statsVM.sessions) { session in
                    Marker("\(session.mode.rawValue): \(session.score)", coordinate: session.coordinate)
                        .tint(session.mode == .tapFrenzy ? .indigo : (session.mode == .lightItUp ? .teal : .purple))
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            .navigationTitle("Match Location Logs")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
