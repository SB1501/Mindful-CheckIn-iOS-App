import Foundation
import UserNotifications
import SwiftUI
import Combine

struct DailyReminderTime: Codable, Equatable {
    var hour: Int
    var minute: Int
}

@MainActor
final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var notificationEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationEnabled, forKey: "notificationEnabled")
        }
    }

    @Published var reminderHour: Int {
        didSet {
            UserDefaults.standard.set(reminderHour, forKey: "reminderHour")
        }
    }

    @Published var reminderMinute: Int {
        didSet {
            UserDefaults.standard.set(reminderMinute, forKey: "reminderMinute")
        }
    }

    private init() {
        self.notificationEnabled = UserDefaults.standard.object(forKey: "notificationEnabled") as? Bool ?? false
        self.reminderHour = UserDefaults.standard.object(forKey: "reminderHour") as? Int ?? 9
        self.reminderMinute = UserDefaults.standard.object(forKey: "reminderMinute") as? Int ?? 0
    }

    var reminderTime: DailyReminderTime {
        get { DailyReminderTime(hour: reminderHour, minute: reminderMinute) }
        set {
            reminderHour = newValue.hour
            reminderMinute = newValue.minute
            UserDefaults.standard.set(reminderHour, forKey: "reminderHour")
            UserDefaults.standard.set(reminderMinute, forKey: "reminderMinute")
        }
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async { completion(granted) }
        }
    }

    func scheduleDailyReminder() async throws {
        let center = UNUserNotificationCenter.current()
        await center.removePendingNotificationRequests(withIdentifiers: [Self.dailyIdentifier])

        let content = UNMutableNotificationContent()
        content.title = "Mindful Check-in"
        content.body = "Got time for a Mindful-Check-in? Tap here to open the app and log how you’re doing."
        content.sound = .default

        var comps = DateComponents()
        comps.hour = reminderHour
        comps.minute = reminderMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: Self.dailyIdentifier, content: content, trigger: trigger)
        try await center.add(request)
    }

    func cancelDailyReminder() async {
        let center = UNUserNotificationCenter.current()
        await center.removePendingNotificationRequests(withIdentifiers: [Self.dailyIdentifier])
    }

    static let dailyIdentifier = "daily_mindful_checkin"
}

