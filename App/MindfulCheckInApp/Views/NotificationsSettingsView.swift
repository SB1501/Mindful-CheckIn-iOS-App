import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @AppStorage("notifications_enabled") private var notificationsEnabled: Bool = false
    @AppStorage("notifications_time") private var notificationsTime: Date = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        let date = calendar.date(from: components) ?? now
        return calendar.date(bySettingHour: 8, minute: 0, second: 0, of: date) ?? now
    }()
    
    @State private var authorizationGranted: Bool = true
    
    var body: some View {
        Form {
            Section {
                Toggle("Daily Reminder", isOn: $notificationsEnabled)
                    .onChange(of: notificationsEnabled) { oldValue, newValue in
                        let enabled = newValue
                        if enabled {
                            requestAuthorization { granted in
                                DispatchQueue.main.async {
                                    authorizationGranted = granted
                                    if granted {
                                        scheduleNotification(at: notificationsTime)
                                    } else {
                                        notificationsEnabled = false
                                    }
                                }
                            }
                        } else {
                            cancelNotification()
                        }
                    }
                
                if notificationsEnabled {
                    DatePicker("Time", selection: $notificationsTime, displayedComponents: .hourAndMinute)
                        .onChange(of: notificationsTime) { oldValue, newValue in
                            let newTime = newValue
                            if notificationsEnabled && authorizationGranted {
                                scheduleNotification(at: newTime)
                            }
                        }
                }
            }
            
            if notificationsEnabled && !authorizationGranted {
                Section {
                    Text("Notifications are disabled at the system level. Please enable notifications in Settings.")
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .onAppear {
            checkAuthorization()
        }
        .navigationTitle("Notifications")
    }
    
    private func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            completion(granted)
        }
    }
    
    private func scheduleNotification(at date: Date) {
        // Placeholder implementation: schedule notification logic here
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder"
        content.body = "This is your daily reminder."
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        center.add(request)
    }
    
    private func cancelNotification() {
        // Placeholder implementation: cancel notification logic here
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
    }
    
    private func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                authorizationGranted = settings.authorizationStatus == .authorized
                if notificationsEnabled && !authorizationGranted {
                    notificationsEnabled = false
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        NotificationSettingsView()
    }
}
