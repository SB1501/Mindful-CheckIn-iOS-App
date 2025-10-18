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
        VStack(spacing: 22) {
            // Title
            Text("Permissions")
                .font(.largeTitle).bold()

            // Big bell image placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .frame(width: 140, height: 140)
                    .overlay(
                        Text("🔔")
                            .font(.system(size: 64))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(Color.black.opacity(0.08), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 8)
            }
            .padding(.top, 4)

            // Prominent explanation paragraph
            Text("Enable notifications to get a gentle daily reminder to check in with yourself. You can change this anytime in Settings.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Existing controls remain
            Text("Stay on Track")
                .font(.title)
                .bold()

            Text("Enable daily reminders to help you check in regularly.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Toggle("Enable Notifications", isOn: $notificationEnabled)
                .onChange(of: notificationEnabled) { _, enabled in
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
                    .onChange(of: reminderTime) { _, newValue in
                        NotificationManager.shared.getAuthorizationStatus { status in
                            if status == .authorized || status == .provisional {
                                NotificationManager.shared.scheduleDailyReminder(at: newValue)
                            }
                        }
                    }
            }

            Spacer()

            // Bottom buttons
            HStack(spacing: 12) {
                NavigationLink(destination: MainMenuView()) {
                    Text("Skip")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.gray.opacity(0.15))
                        )
                }
                .buttonStyle(.plain)

                Button(action: {
                    // Trigger the system permission prompt directly
                    NotificationManager.shared.requestAuthorizationIfNeeded { granted in
                        DispatchQueue.main.async {
                            notificationEnabled = granted
                            if granted {
                                NotificationManager.shared.scheduleDailyReminder(at: reminderTime)
                            } else {
                                showingDeniedAlert = true
                            }
                        }
                    }
                }) {
                    Text("Allow")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.green)
                        )
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal)
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

