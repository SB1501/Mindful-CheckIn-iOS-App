// SB - WelcomeView
// Main screen when loading the app - shown each time it starts. To have logo / nice little introduction


import Foundation
import SwiftUI

struct WelcomeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer: Bool = false
    @State private var goForward = false

    var body: some View {
        NavigationStack {
            ZStack {
                AbstractBackgroundView(
                    colors: [Color.pink, Color.blue, Color.purple, Color.orange],
                    circleCount: 5,
                    blurRadius: 80,
                    seed: 42
                )
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
                        DisclaimerView()
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
                                .fill(Color.appAccent)
                        )
                        .foregroundStyle(.white)
                        .shadow(color: Color.appAccent.opacity(0.35), radius: 10, x: 0, y: 6)
                    }
                    .buttonStyle(.plain)

                    // Hidden trigger view for programmatic navigation
                    Color.clear
                        .frame(width: 0, height: 0)
                        .accessibilityHidden(true)
                }
                .padding()
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $goForward) {
                    Group {
                        if hasAcceptedDisclaimer {
                            MainMenuView()
                        } else {
                            DisclaimerView()
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 115/255, green: 255/255, blue: 255/255), // #73FFFF
                            Color(red: 0/255, green: 251/255, blue: 207/255)    // #00FBCF
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(colorScheme == .light ? 0.44 : 0.36)
                    .blendMode(colorScheme == .light ? .overlay : .plusLighter)
                    .ignoresSafeArea()
                )
                .background(
                    Color(hue: 0.33, saturation: 0.42, brightness: 0.90)
                        .opacity(colorScheme == .light ? 0.34 : 0.28)
                        .blendMode(colorScheme == .light ? .overlay : .plusLighter)
                        .ignoresSafeArea()
                )
            }
        }
        .onAppear {
            // On subsequent runs, skip the welcome screen
            if hasSeenWelcome {
                // Defer to ensure NavigationStack is ready
                DispatchQueue.main.async { goForward = true }
            }
        }
    }
}

