// SB - PermissionsView
// Controls just notifications. Used on the initial setup flow offering a chance to turn on daily notification.

import Foundation
import SwiftUI
import UserNotifications

struct PermissionsView: View {
    // When true, this view is presented modally (e.g., from Settings) and should dismiss on completion.
    var isPresentedModally: Bool = false

    // Onboarding flags
    @AppStorage("hasCompletedNotificationSetup") private var hasCompletedNotificationSetup: Bool = false
    @Environment(\.dismiss) private var dismiss

    // Local UI state for onboarding only
    @State private var notificationsEnabled: Bool = true // suggest ON by default
    @State private var reminderTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var showingDeniedAlert = false
    @State private var goForward = false

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

            Text("Stay on Track")
                .font(.title)
                .bold()

            Text("Enable daily reminders to help you check in regularly.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Toggle("Enable Notifications", isOn: $notificationsEnabled)
                .onChange(of: notificationsEnabled) { _, enabled in
                    // Do not navigate here. Only Allow/Skip advance.
                    Task {
                        if enabled {
                            // No permission prompt here; we will prompt on Allow.
                            // If user toggles ON before Allow, just reflect intent.
                        } else {
                            // If user toggles OFF here, cancel any pending reminder if previously set.
                            await NotificationManager.shared.cancelDailyReminder()
                        }
                    }
                }
                .padding()

            if notificationsEnabled {
                DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
            }

            Spacer()

            // Hidden navigation to Disclaimer
            NavigationLink("", isActive: $goForward) {
                DisclaimerView(isPresentedModally: false)
            }
            .hidden()

            // Bottom buttons
            HStack(spacing: 12) {
                Button {
                    hasCompletedNotificationSetup = true
                    if isPresentedModally {
                        dismiss()
                    } else {
                        goForward = true
                    }
                } label: {
                    Text("Skip")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.gray.opacity(0.15))
                        )
                }
                .buttonStyle(.plain)

                Button {
                    // Request authorization only on explicit Allow.
                    NotificationManager.shared.requestAuthorization { granted in
                        if granted {
                            // Persist time to manager and schedule if toggle is ON
                            let comps = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
                            NotificationManager.shared.reminderTime = DailyReminderTime(hour: comps.hour ?? 9, minute: comps.minute ?? 0)

                            Task {
                                if notificationsEnabled {
                                    try? await NotificationManager.shared.scheduleDailyReminder()
                                } else {
                                    await NotificationManager.shared.cancelDailyReminder()
                                }
                                await MainActor.run {
                                    hasCompletedNotificationSetup = true
                                    if isPresentedModally {
                                        dismiss()
                                    } else {
                                        goForward = true
                                    }
                                }
                            }
                        } else {
                            // Stay on this screen; inform the user and do not advance.
                            showingDeniedAlert = true
                        }
                    }
                } label: {
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
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("OK", role: .cancel) { }
        } message: {
            Text("To enable reminders, allow notifications for this app in Settings.")
        }
    }
}
