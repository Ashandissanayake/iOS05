import SwiftUI

struct SettingsTab: View {
    @EnvironmentObject var statsVM: StatsVM
    @AppStorage("notifications_enabled") private var notificationsEnabled = false
    @State private var alertTime = Date()
    @State private var showingClearConfirmation = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Push Reminders Alerts")) {
                    Toggle("Enable Local Alerts", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { _, newValue in
                            if newValue { NotificationService.shared.requestPermission() }
                            NotificationService.shared.scheduleDailyNotification(at: alertTime, enabled: newValue)
                        }
                    
                    DatePicker("Daily Check-In", selection: $alertTime, displayedComponents: .hourAndMinute)
                        .disabled(!notificationsEnabled)
                        .onChange(of: alertTime) { _, newTime in
                            NotificationService.shared.scheduleDailyNotification(at: newTime, enabled: notificationsEnabled)
                        }
                }
                
                Section(header: Text("Data Actions Maintenance")) {
                    Button(role: .destructive) {
                        showingClearConfirmation = true
                    } label: {
                        Text("Reset System Analytics History")
                    }
                }
            }
            .navigationTitle("Settings Manager")
            .confirmationDialog("Are you absolutely sure?", isPresented: $showingClearConfirmation, titleVisibility: .visible) {
                Button("Delete Everything", role: .destructive) {
                    statsVM.clearStats()
                }
            } message: {
                Text("This action permanently drops database logs, scores, coordinates, and local configurations.")
            }
        }
    }
}
