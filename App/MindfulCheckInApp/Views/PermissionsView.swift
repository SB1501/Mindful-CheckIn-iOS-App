// SB - PermissionsView
// Controls just notifications. Used on the initial setup flow offering a chance to turn on daily notification.

import Foundation
import SwiftUI
import UserNotifications

struct PermissionsView: View {
    @AppStorage("notificationEnabled") private var notificationEnabled = false
    @AppStorage("reminderTime") private var reminderTime: Date = Date()
    @State private var showingDeniedAlert = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Stay on Track")
                .font(.title)
                .bold()
            
            Text("Enable daily reminders to help you check in regularly.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Toggle("Enable Notifications", isOn: $notificationEnabled)
                .onChange(of: notificationEnabled) { enabled in
                    if enabled {
                        NotificationManager.shared.requestAuthorizationIfNeeded { granted in
                            if granted {
                                NotificationManager.shared.scheduleDailyReminder(at: reminderTime)
                            } else {
                                notificationEnabled = false
                                showingDeniedAlert = true
                            }
                        }
                    } else {
                        NotificationManager.shared.cancelAllReminders()
                    }
                }
                .padding()
            
            if notificationEnabled {
                DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
                    .onChange(of: reminderTime) { newValue in
                        NotificationManager.shared.getAuthorizationStatus { status in
                            if status == .authorized || status == .provisional {
                                NotificationManager.shared.scheduleDailyReminder(at: newValue)
                            }
                        }
                    }
            }
            
            NavigationLink("Continue", destination: MainMenuView())
                .buttonStyle(.borderedProminent)
            
            NavigationLink("Skip for Now", destination: MainMenuView())
                .foregroundColor(.gray)
        }
        .padding()
        .alert("Notifications Disabled", isPresented: $showingDeniedAlert) {
            Button("Open Settings") { NotificationManager.shared.openSettings() }
            Button("OK", role: .cancel) { }
        } message: {
            Text("To enable reminders, allow notifications for this app in Settings.")
        }
        .onAppear {
            if notificationEnabled {
                NotificationManager.shared.getAuthorizationStatus { status in
                    if status == .authorized || status == .provisional {
                        NotificationManager.shared.scheduleDailyReminder(at: reminderTime)
                    }
                }
            }
        }
    }
}
