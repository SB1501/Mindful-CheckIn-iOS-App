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
                colors: [Color.orange.opacity(0.85), Color.red.opacity(0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // Big warning image placeholder
                ZStack {

                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 100, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8)
                }
                .padding(.top, 4)

                // Title
                Text("Disclaimer")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8)

                // Lengthy paragraph placeholder
                Text("This app is for reflection and wellbeing support. It does not act as a medical device and does not provide diagnosis or treatment. If you are experiencing distress or a medical emergency, seek professional help. By continuing to use this app, you acknowledge and accept these terms.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.95))
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8)

                Spacer()

                // Bottom-aligned button
                Button(action: {
                    hasAcceptedDisclaimer = true
                    // If this view is presented modally (e.g., from ResourceView), just dismiss.
                    // Otherwise, rely on the navigation stack to continue to the next screen.
                    dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("I understand").bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .foregroundStyle(Color(.red))
                }
                .buttonStyle(.glassProminent)
                .foregroundStyle(Color(.white))
                .padding(.horizontal)
                .tint(Color(.white))
                .padding(.bottom)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview("DisclaimerView") {
    NavigationStack {
        DisclaimerView()
    }
}

