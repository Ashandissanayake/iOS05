import SwiftUI

@main
struct PlayHubApp: App {
    @StateObject private var statsViewModel = StatsVM()
    @StateObject private var locationService = LocationService()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeTab()
                    .tabItem {
                        Label("Home", systemImage: "gamecontroller.fill")
                    }
                
                StatsTab()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.xaxis")
                    }
                
                MapTab()
                    .tabItem {
                        Label("Map Log", systemImage: "map.fill")
                    }
                
                SettingsTab()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .environmentObject(statsViewModel)
            .environmentObject(locationService)
        }
    }
}
