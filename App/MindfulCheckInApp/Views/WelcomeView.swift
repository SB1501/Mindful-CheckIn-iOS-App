// SB - WelcomeView
// Main screen when loading the app - shown each time it starts. To have logo / nice little introduction


import Foundation
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Mindful Check-In")
                    .font(.largeTitle)
                    .bold()
                
                Text("A gentle way to reflect on your body, space, and rhythm.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                NavigationLink("Let’s Go", destination: DisclaimerView())
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
