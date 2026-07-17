import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func scheduleDailyNotification(at date: Date, enabled: Bool) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily_challenge"])
        
        guard enabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "PlayHub Challenge! 🎮"
        content.body = "Time to break your current high scores. Tap in and start playing!"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_challenge", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
