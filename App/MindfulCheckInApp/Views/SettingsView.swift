// SB - SettingsView
// Controls the settings for the app - question management, notifications, data control and about info.

import Foundation
import SwiftUI
import UniformTypeIdentifiers

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

struct ExportTextDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] }
    var text: String
    init(text: String = "") { self.text = text }
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents, let string = String(data: data, encoding: .utf8) {
            text = string
        } else {
            text = ""
        }
    }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8) ?? Data()
        return .init(regularFileWithContents: data)
    }
}

struct SettingsView: View {
    @StateObject private var store = SurveyStore.shared
    @State private var showDeleteAllAlert = false
    @State private var showingExportError = false
    @State private var isFileExporterPresented: Bool = false
    @State private var exportDocument = ExportTextDocument()
    
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer: Bool = false

    @Environment(\.colorScheme) private var colorScheme

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
        AppShell {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Settings")
                        .font(.system(size: 40, weight: .bold))
                    Text("Manage your Check-in experience")
                        .font(.title3)
                        .foregroundStyle(.primary)

                    Divider()
                    
                    // Export Data
                    Button(action: { exportData() }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                Image(systemName: "square.and.arrow.up").font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Export Data").font(.title2).bold()
                                Text("Save past check-ins to a text file").font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    // Delete all data
                    Button(role: .destructive) { showDeleteAllAlert = true } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                Image(systemName: "trash").font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Delete All Data").font(.title2).bold()
                                Text("Removes all past survey information").font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    // License Info
                    NavigationLink(destination: LicenseInfoView()) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                Image(systemName: "doc.text").font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("License Info").font(.title2).bold()
                                Text("MIT License").font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    // App Version (static)
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                )
                            Image(systemName: "info.circle").font(.title3)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("App Version").font(.title2).bold()
                            Text(appVersionText).font(.subheadline).foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )

//                    // Review on the App Store
//                    Button(action: { UIApplication.shared.open(appReviewURL) }) {
//                        HStack(spacing: 12) {
//                            ZStack {
//                                Circle()
//                                    .fill(.ultraThinMaterial)
//                                    .frame(width: 44, height: 44)
//                                    .overlay(
//                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
//                                    )
//                                Image(systemName: "star").font(.title3)
//                            }
//                            VStack(alignment: .leading, spacing: 2) {
//                                Text("Review on the App Store").font(.title2).bold()
//                                Text("Tell the world what you think!").font(.subheadline).foregroundStyle(.secondary)
//                            }
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.gray)
//                        }
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 12, style: .continuous)
//                                .fill(.ultraThinMaterial)
//                        )
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12, style: .continuous)
//                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
//                        )
//                    }
//                    .buttonStyle(.plain)

                    // Buy Me a Coffee (donation)
                    Button(action: {
                        if let url = URL(string: "https://buymeacoffee.com/shanebunting") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                Image(systemName: "cup.and.saucer").font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Buy Me a Coffee").font(.title2).bold()
                                Text("Support the apps development").font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    // Send Feedback
                    Button(action: { if let url = feedbackURL { UIApplication.shared.open(url) } }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                Image(systemName: "envelope").font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Send Feedback").font(.title2).bold()
                                Text("Tell me what you think!").font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    // Reset Welcome
                    Button(role: .destructive) {
                        hasSeenWelcome = false
                        hasAcceptedDisclaimer = false
                    } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                Image(systemName: "arrow.counterclockwise").font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Reset Welcome").font(.title2).bold()
                                Text("Restore Welcome Screen on next start").font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                }
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 115/255, green: 255/255, blue: 255/255),
                        Color(red: 0/255, green: 251/255, blue: 207/255)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(colorScheme == .light ? 0.44 : 0.36)
                .blendMode(colorScheme == .light ? .overlay : .plusLighter)
                .ignoresSafeArea()
            )
        }
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
        .fileExporter(
            isPresented: $isFileExporterPresented,
            document: exportDocument,
            contentType: .plainText,
            defaultFilename: defaultExportFilename
        ) { result in
            if case .failure(_) = result { showingExportError = true }
        }
    }

    private func exportData() {
        let text = buildExportText()
        exportDocument = ExportTextDocument(text: text)
        isFileExporterPresented = true
    }

    private var defaultExportFilename: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm"
        return "MindfulCheckinExport_\(formatter.string(from: Date())).txt"
    }

    private func buildExportText() -> String {
        var lines: [String] = []
        lines.append("Mindful Check-in Export")
        lines.append(Date().formatted(date: .abbreviated, time: .standard))
        lines.append("Total records: \(store.records.count)")
        lines.append("")
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        for record in store.records {
            lines.append("=== Record ===")
            lines.append("Date: \(df.string(from: record.date))")
            lines.append("Summary: Good \(record.summary.good) • Neutral \(record.summary.neutral) • Needs Attention \(record.summary.bad)")
            let note = record.reflection.trimmingCharacters(in: .whitespacesAndNewlines)
            lines.append("Reflection: \(note.isEmpty ? "-" : note)")
            if !record.positiveTopics.isEmpty {
                lines.append("Doing well on: " + record.positiveTopics.map { $0.displayName }.joined(separator: ", "))
            }
            if !record.neutralTopics.isEmpty {
                lines.append("Okay on: " + record.neutralTopics.map { $0.displayName }.joined(separator: ", "))
            }
            if !record.flaggedTopics.isEmpty {
                lines.append("Mindful of: " + record.flaggedTopics.map { $0.displayName }.joined(separator: ", "))
            }
            lines.append("")
        }
        return lines.joined(separator: "\n")
    }
}

// MARK: - Placeholder subviews (replace with your real implementations as needed)

struct LicenseInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("License")
                    .font(.title).bold()

                Text("This project is open for reuse as a portfolio piece with real‑world utility. You’re welcome to read the code, learn from it, and reuse it in your own projects under the terms of the MIT License. The full code can be found on GitHub (SB1501).")

                Group {
                    Text("License: MIT License")
                        .font(.headline)
                    Text("A permissive open‑source license allowing reuse with attribution")
                        .foregroundStyle(.secondary)
                    Text("Summary")
                        .font(.headline)
                    Text("• You may use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software.")
                    Text("• Attribution is appreciated by including the copyright notice and license text in copies or substantial portions of the software.")
                    Text("• The software is provided without warranty of any kind.")
                }

                Group {
                    Text("Notes")
                        .font(.headline)
                    Text("MIT is a widely used, OSI‑approved license that enables broad reuse, including commercial use. This aligns with your intent to make the project freely reusable as part of your portfolio.")
                }

                Group {
                    Text("No warranty")
                        .font(.headline)
                    Text("THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.")
                }

                Group {
                    Text("Commercial use")
                        .font(.headline)
                    Text("Commercial use is permitted under the MIT License. If you use this project, attribution is appreciated.")
                }

                Group {
                    Text("Learn more")
                        .font(.headline)
                    if let url = URL(string: "https://opensource.org/license/mit/") {
                        Link("MIT License (opensource.org)", destination: url)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

#Preview {
    SettingsView()
}
