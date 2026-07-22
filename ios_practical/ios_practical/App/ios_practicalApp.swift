import SwiftUI

@main
struct ios_practicalApp: App {
    @StateObject private var statsVM = StatsVM()
    @StateObject private var locationService = LocationService()
    @StateObject private var notificationService = NotificationService()
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(statsVM)
                .environmentObject(locationService)
                .environmentObject(notificationService)
                .preferredColorScheme(.dark)
        }
    }
}

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeTab()
                .tabItem {
                    Label("Home", systemImage: "gamecontroller.fill")
                }
            
            StatsTab()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
            
            MapTab()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            
            SettingsTab()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}
