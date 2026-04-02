// SB - WelcomeView
// Main screen when loading the app - shown each time it starts. To have logo / nice little introduction


import Foundation
import SwiftUI

struct WelcomeView: View { //main class definition for WelcomeView
    @Environment(\.colorScheme) private var colorScheme //light or dark mode Environment variable read from device
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false //variable stored across app for settings to change to ensure this doesn't appear every start unuless reset
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer: Bool = false //variable stores if disclaimer was seen for first run, also reset in settings by user if they want
    
    @State private var goForward = false //variable to change when 'let's go' is pressed to allow NavigationStack to proceed to disclaimer view
    @State private var goToMainMenu = false

    var body: some View { //main on screen UI View definition
            NavigationStack { //navigation stack used to hand off between WelcomeView and DisclaimerView which follows
                AppShell {
                    ZStack {
                        
                        VStack(spacing: 24) {
                            //top welcome text
                            Spacer()
                            Text("Welcome to")
                                .font(.title3)
                                .foregroundStyle(.primary)
                            
                            //app logo
                            VStack(spacing: 24) {
                                Image("logowhite")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(16)
                                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 8)
                            }
                            .padding(.top, 8)
                            
                            //descriptive paragraph
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
                                        .foregroundStyle(Color(.white))
                                }
                                .frame(maxWidth: .infinity) //makes button wide to keep consistent with others in the app
                                .padding(.vertical, 20) //keeps the button taller
                                .background(
                                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                                    .fill(Color.appAccent)
                                    .foregroundStyle(.white)
                                    )
                                .buttonStyle(.glassProminent) //new liquid glass styling
                                .tint(Color(.white)) //body colour
                                .shadow(color: Color.appAccent.opacity(0.35), radius: 10, x: 0, y: 6)
                            }
                            
                        }
                        .foregroundStyle(Color(.white)) //body colour
                        .padding(.horizontal) //edge padding outside button
                        
                        .padding(.bottom)
                            
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
                        .navigationDestination(isPresented: $goToMainMenu) {
                            MainMenuView()
                                .navigationBarBackButtonHidden(true)
                        }
                    }
                    .background(
                        LinearGradient( //defines a gradient with two custom colours:
                            colors: [
                                Color(red: 115/255, green: 255/255, blue: 255/255),
                                Color(red: 0/255, green: 251/255, blue: 207/255)
                            ],
                            startPoint: .topLeading, //gradient start
                            endPoint: .bottomTrailing //gradient stop
                        ) //modifiers for LinearGradient:
                        .opacity(colorScheme == .light ? 0.44 : 0.36) //transparency
                        .blendMode(colorScheme == .light ? .overlay : .plusLighter) //allows special blend effect / overlay
                        .ignoresSafeArea() //fills entire canvas, including home button area and menu bar
                        
                    ) //end of background
                }
            .onAppear {
                //on subsequent runs, skip the welcome screen
                if hasSeenWelcome {
                    // Defer to ensure NavigationStack is ready
                    DispatchQueue.main.async { goForward = true }
                }
            }
            .onChange(of: hasAcceptedDisclaimer) { _, accepted in
                if accepted {
                    // User accepted the disclaimer; show the main menu next.
                    DispatchQueue.main.async {
                        goToMainMenu = true
                    }
                }
            }
        }
        
            
        }

#Preview {WelcomeView()}

