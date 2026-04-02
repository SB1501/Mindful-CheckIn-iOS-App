// SB MINDFUL CHECK IN - MainMenuView
// Controls the Main Menu options, points to the main views and functions of the app

import Foundation
import SwiftUI

//CLASS DEFINITION AND STATE VARIABLES
struct MainMenuView: View {
    @State private var breathe = false //State variables for animations within this class...
    @State private var logoDrift = false //as above
    @Environment(\.colorScheme) private var colorScheme //Environment variable that reads the current device environment setting for light or dark mode

    //CLASS MAIN VIEW BODY
    var body: some View { //required View property to where layout is described
        
        NavigationStack { //provides a navigation context for pushing destination views via NavigationLINK
            
            AppShell { //wraps everything following it within the custom defined AppShell class, which brings AbstractBackgroundView to be the background here with circles / movements
                
                VStack(spacing: 28) { //This vertical stack shows each defined item on top of / below each other in order of top to bottom. The 28 is the spacing between all children inside it

                    VStack(spacing: 8) { //inner vertical stack for logo, tighter spacing...
                        
                                Image("logowhitepng") //logo, with modifiers:
                                    .resizable() //forces away from actual size and aspect ratio
                                    .scaledToFit() //ensures fits within the parent without ruining original aspect ratio
                                    .padding(16)
                                    .colorInvert() //turns black logo png into white for app
                                    .brightness(logoDrift ? 0.02 : -0.02) //varies brightness while the logo breathe-motion moves
                                    .saturation(logoDrift ? 1.02 : 0.98) //varies the saturation while the logo drift-motion moves
                                    .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: logoDrift) //animation used for drift around motion, to repeat forever
                                    .opacity(logoDrift ? 0.96 : 0.88) //varies the opacity while the logo drift-motion moves

                        //...we are still in the child VSTACK above, the following elements follow the logo as one unit within the main body VSTACK which we are also still in...//

                    
                        Text("it's time to check-in") //sub-title text
                            .font(.largeTitle).bold() //bold
                            .foregroundStyle(.primary) //built in SwiftUI text style
                            .padding(.top, 4) //spacing between logo and sub heading
                            .scaleEffect(breathe ? 1.02 : 0.98) //pulsing effect intensity
                            .opacity(breathe ? 0.9 : 0.65) //varies the opacity while the logo breathe-motion moves
                            .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: breathe) //animation used for breathe in and out, to repeat forever
                    } //modifiers for the VSTACK for the logo  / sub header follow:
                    .onAppear {
                        breathe = true //flip the animations on only when this appears
                        logoDrift = true
                    }
                    .padding(.top, 24) //further spacing tuning

                    //..we are still within the main VSTACK but out of the cluster for logo and sub-heading, what follows is vertically below..//
                    
                    
                    
                    VStack(spacing: 16) { //inner VSTACK for the Main Menu Buttons. Each item below is vertically ordered to follow each other. It is a custom UI element defined in a method at the bottom of this class...
                        
                        MenuGlassButton(systemIconName:  "checklist", title: "Check In") {
                            //AppShell {
                                SurveyFlowView() //Start Check-In
                            //}
                        }
                        //each of these calls the function, passes in an icon, title to show, then the destination view - different for each....
                        
                        MenuGlassButton(systemIconName: "books.vertical.fill", title: "Resources") {
                            AppShell {
                                ResourceHomeView() //View Resource List
                            }
                        }
                        MenuGlassButton(systemIconName: "clock.arrow.circlepath", title: "Past Records") {
                            AppShell {
                                PastRecordsView() //View Past Records
                            }
                        }
                        MenuGlassButton(systemIconName: "gearshape.fill", title: "Settings") {
                            AppShell {
                                SettingsView() //Enter Settings
                            }
                        }
                    }
                    .padding(.horizontal)

                    
                    Text("App by Shane Bunting") //SB credit text, with modifiers:
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)

                    Spacer(minLength: 0) //pushes the content overall UP within this VSTACK
                    
                }
                .navigationBarBackButtonHidden(true) //hides the back so the onboarding flow can't be returned to by the user
                
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
                
            } //End of AppShell

        } //End of NavigationStack
        .navigationTitle("Main Menu")
        .navigationBarHidden(true)

    } //End of main class View body
    
    
} //End of Struct for MainMenuView itself


//ADDITIONAL CUSTOM METHODS FOLLOW

private struct MenuGlassButton<Destination: View>: View { //Definition for custom large main menu glass buttons
    
    let systemIconName: String //intake variable for icon
    let title: String //intake variable for title
    @ViewBuilder var destination: () -> Destination //this closure returns a destination, used for how the button navigates below...

    var body: some View { //MAIN BODY OF CLASS - defines UI elements that build it and appear on screen, required for View protocol
        
        NavigationLink(destination: destination()) { //NavigationLink that pushes destination() when tapped... working with NavigationStack in the main UI class body above which calls them...
            
            HStack(spacing: 14) { //HSTACK so every item within follows one another left to right in that order top to bottom, in this case the icon, title, and chevron...
                
                Image(systemName: systemIconName) //placeholder for each icon, icon variable is passed into this each time a custom button is called. Styling modifiers:
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle().fill(.ultraThinMaterial)
                    )
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )

                Text(title) //placeholder for passed in title string, and style modifiers:
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer() //spacer, but applies horizontally this time

                Image(systemName: "chevron.right") //hard coded chevron since it doesn't change and isn't passed in each time, every button has one. Modifiers:
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
            } //modifiers for this HStack defining one button:
            //.padding(.horizontal, 18)
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous) //rounded corners
                    .fill(.ultraThinMaterial) //new glass material style
            )
            .overlay( //darker grey feel to the button style...
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.35), lineWidth: 1) //with white outline
            )
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 8) //shadow above background
        }
        .buttonStyle(.plain) //removes default blue text / styling 
    }
}


#Preview("MainMenuView") {
    NavigationStack {
        MainMenuView()
    }
}

