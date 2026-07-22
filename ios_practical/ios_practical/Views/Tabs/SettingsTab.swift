// ios_practical/ios_practical/Views/Tabs/SettingsTab.swift

import SwiftUI
import UserNotifications

struct SettingsTab: View {
    @EnvironmentObject var statsVM: StatsVM
    
    @AppStorage("game_round_length") private var roundLength: Int = 60
    @AppStorage("daily_reminder_enabled") private var reminderEnabled: Bool = false
    @AppStorage("daily_reminder_time") private var reminderTimeInterval: Double = Date().timeIntervalSince1970
    
    @State private var reminderTime: Date = Date()
    @State private var showResetConfirmation = false
    
    private let roundLengthOptions = [30, 60, 90]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.24, green: 0.12, blue: 0.48),
                    Color(red: 0.05, green: 0.02, blue: 0.15),
                    .black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Text("Settings")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 12)
                    
                    // MARK: Gameplay
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Gameplay")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                        
                        RoundLengthPicker(selection: $roundLength, options: roundLengthOptions)
                    }
                    
                    // MARK: Notifications
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Notifications")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                        
                        VStack(spacing: 0) {
                            HStack {
                                Text("Reminder Time")
                                    .foregroundColor(.white)
                                Spacer()
                                DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .colorScheme(.dark)
                                    .onChange(of: reminderTime) { newValue in
                                        reminderTimeInterval = newValue.timeIntervalSince1970
                                        if reminderEnabled {
                                            scheduleReminder()
                                        }
                                    }
                            }
                            .padding()
                            
                            Divider()
                                .background(Color.white.opacity(0.1))
                                .padding(.horizontal)
                            
                            Button(action: {
                                reminderEnabled.toggle()
                                if reminderEnabled {
                                    requestNotificationPermissionAndSchedule()
                                } else {
                                    cancelReminder()
                                }
                            }) {
                                HStack {
                                    Text(reminderEnabled ? "Daily Reminder Enabled" : "Enable Daily Reminder")
                                        .foregroundColor(.cyan)
                                    Spacer()
                                    if reminderEnabled {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.cyan)
                                    }
                                }
                                .padding()
                            }
                        }
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(18)
                    }
                    
                    // MARK: Reset Stats
                    Button(action: {
                        showResetConfirmation = true
                    }) {
                        Text("Reset All Stats")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.15))
                            .cornerRadius(16)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            reminderTime = Date(timeIntervalSince1970: reminderTimeInterval)
        }
        .alert("Reset All Stats?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                statsVM.clearStats()
            }
        } message: {
            Text("This will permanently delete all recorded game sessions and scores. This cannot be undone.")
        }
    }
    
    private func requestNotificationPermissionAndSchedule() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    scheduleReminder()
                } else {
                    reminderEnabled = false
                }
            }
        }
    }
    
    private func scheduleReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_game_reminder"])
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Play!"
        content.body = "Come back and beat your high score."
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "daily_game_reminder", content: content, trigger: trigger)
        center.add(request)
    }
    
    private func cancelReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily_game_reminder"])
    }
}

private struct RoundLengthPicker: View {
    @Binding var selection: Int
    let options: [Int]
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = option
                    }
                }) {
                    Text("\(option) seconds")
                        .font(.subheadline)
                        .fontWeight(selection == option ? .semibold : .regular)
                        .foregroundColor(selection == option ? .black : .white.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(selection == option ? Color.white : Color.clear)
                        )
                }
            }
        }
        .padding(4)
        .background(Capsule().fill(Color.white.opacity(0.1)))
    }
}
