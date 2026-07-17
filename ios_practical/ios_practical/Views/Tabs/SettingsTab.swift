import SwiftUI

struct SettingsTab: View {
    @AppStorage("round_duration_setting") private var roundDuration: Double = 60.0
    
    var body: some View {
        Form {
            Section(header: Text("Game Configurations")) {
                Picker("Round Length", selection: $roundDuration) {
                    Text("30 Seconds").tag(30.0)
                    Text("60 Seconds").tag(60.0)
                    Text("90 Seconds").tag(90.0)
                }
                .pickerStyle(.segmented)
            }
            
            Section(footer: Text("Adjust configuration options across all available sub-game structures.")) {}
        }
        .navigationTitle("Settings")
    }
}
