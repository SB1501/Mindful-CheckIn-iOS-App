// SB - DisclaimerView
// Controls the Disclaimer at the start of the app and used throughout next to anything that may be perceived as advice.

import Foundation
import SwiftUI

struct DisclaimerView: View {
    @AppStorage("hasCompletedNotificationSetup") private var hasCompletedNotificationSetup = false
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer: Bool = false

    var body: some View {
        ZStack {
            // Appealing red gradient background
            LinearGradient(
                colors: [Color.red.opacity(0.85), Color.orange.opacity(0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // Title
                Text("Disclaimer")
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                    .padding(.top, 8)

                // Big warning image placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .frame(width: 160, height: 160)
                        .overlay(
                            Text("⚠️")
                                .font(.system(size: 72))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8)
                }
                .padding(.top, 4)

                // Lengthy paragraph placeholder
                Text("This app is for reflection and wellbeing support. It is not a medical device and does not provide diagnosis or treatment. If you are experiencing distress or a medical emergency, seek professional help. By continuing, you acknowledge and accept these terms.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.95))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .opacity(0.35)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .padding(.horizontal)

                Spacer()

                // Bottom-aligned button
                Button(action: {
                    hasAcceptedDisclaimer = true
                    // If this view is presented modally (e.g., from ResourceView), just dismiss.
                    // Otherwise, rely on the navigation stack to continue to the next screen.
                    dismiss()
                }) {
                    Text("I understand")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                        )
                        .foregroundStyle(Color.red)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding()
        }
    }
}
