// SB - MainMenuView
// Controls the Main Menu options, pointed to by various other buttons and views...

import Foundation
import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Mindful Check-In")
                    .font(.largeTitle)
                    .bold()
                NavigationLink("Check In", destination: SurveyFlowView())
                NavigationLink("Resources", destination: ResourceHomeView())
                NavigationLink("Past Records", destination: PastRecordsView())
                NavigationLink("Settings", destination: SettingsView())
            }
            .padding()
        }
    }
}
