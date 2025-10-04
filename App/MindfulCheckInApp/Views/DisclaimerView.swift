// SB - DisclaimerView
// Controls the Disclaimer at the start of the app and used throughout next to anything that may be perceived as advice.

import Foundation
import SwiftUI

struct DisclaimerView: View {
    @AppStorage("hasCompletedNotificationSetup") private var hasCompletedNotificationSetup = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Disclaimer")
                .font(.title)
            Text("This app is not a medical tool or for advice. It’s here to help you reflect and regulate.")
                .multilineTextAlignment(.center)
                .padding()
            if hasCompletedNotificationSetup {
                NavigationLink("I Understand", destination: MainMenuView())
                    .buttonStyle(.borderedProminent)
            } else {
                NavigationLink("I Understand", destination: PermissionsView())
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

