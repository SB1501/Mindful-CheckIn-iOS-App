// SB - MainMenuView
// Controls the Main Menu options, pointed to by various other buttons and views...

import Foundation
import SwiftUI

struct MainMenuView: View {
    var body: some View {
        ZStack {
            // Subtle background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                // Logo / Title placeholder
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Text("🧠")
                                .font(.system(size: 56))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 6)

                    Text("Mindful Check-In")
                        .font(.largeTitle).bold()
                        .foregroundStyle(.primary)
                        .padding(.top, 4)
                }
                .padding(.top, 24)

                // Big Liquid Glass buttons
                VStack(spacing: 16) {
                    MenuGlassButton(icon: "📝", title: "Check In") {
                        SurveyFlowView()
                    }
                    MenuGlassButton(icon: "📚", title: "Resources") {
                        ResourceHomeView()
                    }
                    MenuGlassButton(icon: "🗂️", title: "Past Records") {
                        PastRecordsView()
                    }
                    MenuGlassButton(icon: "⚙️", title: "Settings") {
                        SettingsView()
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 0)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

private struct MenuGlassButton<Destination: View>: View {
    let icon: String
    let title: String
    @ViewBuilder var destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
            HStack(spacing: 14) {
                // Icon / emoji placeholder
                Text(icon)
                    .font(.system(size: 28))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle().fill(.ultraThinMaterial)
                    )
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )

                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.35), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }
}

