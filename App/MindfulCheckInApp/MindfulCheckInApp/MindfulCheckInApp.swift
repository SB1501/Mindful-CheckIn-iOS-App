//
//  MindfulCheckInApp.swift
//  MindfulCheckInApp
//
//  Created by Shane Bunting on 20/09/2025.
//

import SwiftUI

@main
struct MindfulCheckInApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView()
            }
            .tint(Color.appAccent)
            .preferredColorScheme(.dark)
        }
    }
}

