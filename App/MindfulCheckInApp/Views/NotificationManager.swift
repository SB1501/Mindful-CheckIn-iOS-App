// SB - NotificationManager
// Controls notifications, but the actual technical side of how they work - not permissions. 

import Foundation
import UserNotifications
import UIKit

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    // Authorisation
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }

    // Requests authorisation only if status is .notDetermined
    func requestAuthorizationIfNeeded(completion: @escaping (_ granted: Bool) -> Void) {
        getAuthorizationStatus { status in
            switch status {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                    DispatchQueue.main.async {
                        completion(granted)
                    }
                }
            case .denied:
                DispatchQueue.main.async { completion(false) }
            case .authorized, .provisional, .ephemeral:
                DispatchQueue.main.async { completion(true) }
            @unknown default:
                DispatchQueue.main.async { completion(false) }
            }
        }
    }

    // Scheduling
    func scheduleDailyReminder(at date: Date) {
        let center = UNUserNotificationCenter.current()

        // Remove existing request with same identifier to avoid duplicates
        center.removePendingNotificationRequests(withIdentifiers: ["daily.reminder"]) 

        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        dateComponents.second = 0

        let content = UNMutableNotificationContent()
        content.title = "Mindful Check-In"
        content.body = "Take a moment to reflect and check in."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily.reminder", content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }

    func cancelAllReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // Settings
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
