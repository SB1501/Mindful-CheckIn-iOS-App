// SB - MainMenuView
// Controls the Main Menu options, pointed to by various other buttons and views...

import Foundation
import SwiftUI

struct MainMenuView: View {
    @State private var breathe = false
    @State private var logoDrift = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            AppShell {
                VStack(spacing: 28) {
                    // Logo / Title placeholder
                    VStack(spacing: 8) {
                        
                                Image("logowhitepng")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(16) // adjust padding to taste
                                    .colorInvert()
                                    .brightness(logoDrift ? 0.02 : -0.02)
                                    .saturation(logoDrift ? 1.02 : 0.98)
                                    .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: logoDrift)
                                    .opacity(logoDrift ? 0.96 : 0.88)


                    
                        Text("it's time to check-in")
                            .font(.largeTitle).bold()
                            .foregroundStyle(.primary)
                            .padding(.top, 4)
                            .scaleEffect(breathe ? 1.02 : 0.98)
                            .opacity(breathe ? 0.9 : 0.65)
                            .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: breathe)
                    }
                    .onAppear {
                        breathe = true
                        logoDrift = true
                    }
                    .padding(.top, 24)

                    // Big Liquid Glass buttons
                    VStack(spacing: 16) {
                        MenuGlassButton(systemIconName: "checklist", title: "Check In") {
                            AppShell {
                                SurveyFlowView()
                            }
                        }
                        MenuGlassButton(systemIconName: "books.vertical.fill", title: "Resources") {
                            AppShell {
                                ResourceHomeView()
                            }
                        }
                        MenuGlassButton(systemIconName: "clock.arrow.circlepath", title: "Past Records") {
                            AppShell {
                                PastRecordsView()
                            }
                        }
                        MenuGlassButton(systemIconName: "gearshape.fill", title: "Settings") {
                            AppShell {
                                SettingsView()
                            }
                        }
                    }
                    .padding(.horizontal)

                    Text("App by Shane Bunting")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)

                    Spacer(minLength: 0)
                }
                .padding()
                .navigationBarBackButtonHidden(true)
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
        }
    }
}

private struct MenuGlassButton<Destination: View>: View {
    let systemIconName: String
    let title: String
    @ViewBuilder var destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
            HStack(spacing: 14) {
                // Icon / emoji placeholder
                Image(systemName: systemIconName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
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


#Preview("MainMenuView") {
    NavigationStack {
        MainMenuView()
    }
}

