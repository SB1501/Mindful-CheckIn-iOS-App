// SB - WelcomeView
// Main screen when loading the app - shown each time it starts. To have logo / nice little introduction


import Foundation
import SwiftUI

struct WelcomeView: View {
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer: Bool = false
    @AppStorage("resetOnboarding") private var resetOnboarding: Bool = false
    @State private var goForward = false
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // Soft background gradient
                LinearGradient(colors: [Color.green.opacity(0.12), Color.teal.opacity(0.12)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    // Top welcome text
                    Text("Welcome to")
                        .font(.title3)
                        .foregroundStyle(.secondary)

                    // Big logo placeholder
                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .frame(width: 180, height: 180)
                            .overlay(
                                Text("🧘‍♀️")
                                    .font(.system(size: 72))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 8)

                        Text("Mindful Check-In")
                            .font(.largeTitle).bold()
                            .foregroundStyle(.primary)
                    }
                    .padding(.top, 8)

                    // Prominent paragraph placeholder
                    Text("Take a moment to gently reflect on your body, space, and rhythm. Explore patterns, build awareness, and find your balance.")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                        .padding(.horizontal)

                    Spacer()

                    // Big green Let's Go button at the bottom
                    NavigationLink {
                        PermissionsView()
                            .navigationBarBackButtonHidden(true)
                            .onAppear { hasSeenWelcome = true }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Let’s Go")
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.green)
                        )
                        .foregroundStyle(.white)
                        .shadow(color: Color.green.opacity(0.35), radius: 10, x: 0, y: 6)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .onChange(of: hasAcceptedDisclaimer) { oldValue, newValue in
                    if newValue {
                        // When disclaimer accepted, route to main menu and clear back stack
                        path = NavigationPath()
                        path.append("main")
                    }
                }
                .onAppear {
                    // Determine whether onboarding should run: first launch or explicit reset
                    let shouldRunOnboarding = resetOnboarding || !hasSeenWelcome
                    DispatchQueue.main.async {
                        path = NavigationPath()
                        if shouldRunOnboarding {
                            // If we were asked to reset onboarding, clear the flag so it only runs once
                            if resetOnboarding { resetOnboarding = false }
                            if hasAcceptedDisclaimer {
                                // Edge case: disclaimer already accepted but onboarding reset requested -> go to main
                                path.append("main")
                            } else {
                                // Start onboarding at permissions
                                path.append("permissions")
                            }
                        } else {
                            // Normal subsequent runs -> go straight to main menu
                            path.append("main")
                        }
                    }
                }
            }
            .navigationDestination(for: String.self) { route in
                switch route {
                case "permissions":
                    PermissionsView()
                        .navigationBarBackButtonHidden(true)
                case "main":
                    MainMenuView()
                        .navigationBarBackButtonHidden(true)
                default: EmptyView()
                }
            }
        }
    }
}

