import SwiftUI
import UserNotifications

class NotificationManager {
    
    static let instance = NotificationManager()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Success")
            }
        }
    }
    
    func scheduleNotification(s: String, startDate: Date, times: Int) {
        let content = UNMutableNotificationContent()
        content.title = "食品过期提醒"
        content.subtitle = "您的\(s)等食品即将过期啦, 快来看看吧～"
        content.sound = .default
        content.badge = 1
        
        let t = times + 2
        var d = startDate
        for _ in 1...t {
            if (d > Date()) {
                let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: d)
                let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
                let i = UUID().uuidString
                let request = UNNotificationRequest(identifier: i, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
                d = Calendar.current.date(byAdding: .day, value: 1, to: d)!
            } else {
                d = Calendar.current.date(byAdding: .day, value: 1, to: d)!
            }
                                                
        }
        
    }
                                                
}
