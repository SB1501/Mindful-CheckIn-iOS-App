// SB - SettingsView
// Controls the settings for the app - question management, notifications, data control and about info.

import Foundation
import SwiftUI

struct LiquidGlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 20
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
    }
}

struct SettingsView: View {
    @StateObject private var store = SurveyStore.shared
    @State private var showDeleteAllAlert = false
    @State private var showingExportError = false

    private var appVersionText: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
        return "\(version) (\(build))"
    }

    private var feedbackURL: URL? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        let subject = "Mindful Check-in App Feedback - \(date)"
        let email = "sabunting@icloud.com"
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subject
        let urlString = "mailto:\(email)?subject=\(encodedSubject)"
        return URL(string: urlString)
    }

    private let appReviewURL = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review")!

    var body: some View {
        List {
            Section {
                LiquidGlassCard {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Settings")
                            .font(.largeTitle)
                            .bold()
                        Text("Customise your Check-in experience")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Divider()
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }

            Section("Check-in") {
                LiquidGlassCard {
                    NavigationLink("Question Management", destination: QuestionManagementView())
                }
                .listRowBackground(Color.clear)
            }

            Section("Notifications") {
                LiquidGlassCard {
                    NavigationLink("Notifications", destination: NotificationsSettingsView())
                }
                .listRowBackground(Color.clear)
            }

            Section("Data & Privacy") {
                LiquidGlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Button("Export Data") {
                            exportData()
                        }
                        Button(role: .destructive) {
                            showDeleteAllAlert = true
                        } label: {
                            Label("Delete all my data", systemImage: "trash")
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }

            Section("About") {
                LiquidGlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        NavigationLink("License Info", destination: LicenseInfoView())
                        HStack {
                            Text("App Version")
                            Spacer()
                            Text(appVersionText)
                                .foregroundStyle(.secondary)
                        }
                        Button("Send Feedback") {
                            if let url = feedbackURL { UIApplication.shared.open(url) }
                        }
                        Button("Review on the App Store") {
                            UIApplication.shared.open(appReviewURL)
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        .alert("Delete All Data?", isPresented: $showDeleteAllAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                store.removeAll()
            }
        }
        .alert("Export Failed", isPresented: $showingExportError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("We couldn't export your data. Please try again.")
        }
    }

    private func exportData() {
        do {
            let exportText = "Mindful Check-in Export\n\n(placeholder)"
            let tempDir = FileManager.default.temporaryDirectory
            let fileURL = tempDir.appendingPathComponent("MindfulCheckinExport.txt")

            try exportText.write(to: fileURL, atomically: true, encoding: .utf8)

            // Since presenting a share sheet is not directly possible here,
            // as a placeholder, attempt to open the file URL.
            UIApplication.shared.open(fileURL)

        } catch {
            showingExportError = true
        }
    }
}

// MARK: - Placeholder subviews (replace with your real implementations as needed)

struct QuestionManagementView: View {
    var body: some View {
        List {
            Text("Manage which questions appear during check-in.")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Question Management")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationsSettingsView: View {
    @AppStorage("notifications_enabled") private var notificationsEnabled: Bool = false
    @AppStorage("notifications_time") private var notificationsTime: Date = {
        var comps = DateComponents()
        comps.hour = 8; comps.minute = 0
        return Calendar.current.date(from: comps) ?? Date()
    }()

    var body: some View {
        Form {
            Toggle("Daily Reminder", isOn: $notificationsEnabled)
            if notificationsEnabled {
                DatePicker("Time", selection: $notificationsTime, displayedComponents: .hourAndMinute)
            }
            Section(footer: Text("Make sure notifications are allowed in iOS Settings > Notifications if reminders don't appear.")) {
                EmptyView()
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LicenseInfoView: View {
    var body: some View {
        ScrollView {
            Text("License information goes here.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .navigationTitle("License Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}
