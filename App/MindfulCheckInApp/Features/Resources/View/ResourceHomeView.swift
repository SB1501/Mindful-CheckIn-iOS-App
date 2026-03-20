// SB - ResourceHomeView
// Controls the view with all the question topics / subjects for reading / learning.

import Foundation
import SwiftUI


struct ResourceHomeView: View { //defining the primary struct conforming to the View protocol as required by SwiftUI
    
    @Environment(\.colorScheme) private var colorScheme //reads the system colour scheme (dark/light) from the @Environment
    @State private var showingDisclaimer = false //initial state of disclaimer is set to false
    
    var body: some View { //the main View within SwiftUI with everything within showing on screen

        AppShell { //calls AppShell to wrap this view with the fullscreen background used across the app
            
            NavigationStack { //provides the navigation push/pop for content and interaction from user
                
                ScrollView { //everything within is scrollable
                    
                    VStack(alignment: .leading, spacing: 24) { //VStack - everything within follows one another vertically / top to bottom
                        
                        Text("Resources") //title with style modifiers:
                            .font(.system(size: 40, weight: .bold))
                            .multilineTextAlignment(.leading)
                        
                        Text("Explore topics that support your wellbeing. Tap any to learn more about what it means, why it matters, and how to manage it.") //description text, with style modifiers:
                            .font(.title3)
                            .foregroundStyle(.primary)
                        
                        Divider() //spacing and light line
                        
                        // TOPIC BUTTON LOOP

                        ForEach(QuestionTopic.allCases, id: \.self) { topic in //iterates over each QuestionTopic and generates a pushable button on a new row for each
                            
                            NavigationLink(destination: ResourceView(topic: topic)) { //when each topic is tapped, controls where it goes (calls ResourceView and passes it a topic)
                                
                                //within each button...
                                HStack(spacing: 12) { //an HStack (everything within follows each other left to right)
                                    
                                    ZStack { //ZStack (everything within follows front to back, for putting icon over a circle)
                                        Circle() //draws a circle, with style modifiers:
                                            .fill(topic.color.opacity(0.25)) //colour and opacity
                                            .frame(width: 44, height: 44) //size
                                        
                                        Image(systemName: topic.symbolName) //defines an image, on top of the circle above since inside a ZStack, with style modifiers:
                                            .font(.title3)
                                            .foregroundStyle(.white)
                                    }
                                    
                                    VStack(alignment: .leading) { //Vstack follows the icon, this is the title...
                                        Text(topic.resourceTitle) //text using the current resourceTitle for this iteration of the loop defining this part of the view
                                            .font(.title2) //style
                                            .bold() //style
                                            .foregroundColor(.white) //main colour
                                    }
                                    
                                    Spacer() //space after title
                                    
                                    Image(systemName: "chevron.right") //right arrow at the end of the button
                                        .foregroundColor(.white) //style
                                    
                                } //end of HStack defining what goes in each button. Style modifiers apply to each button repeated as below:
                                .padding() //bulks up inside button to use more space
                                .background( //colour and corner style
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(topic.backgroundColor)
                                )
                                .overlay( //edge styling outline
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .strokeBorder(Color.white.opacity(0.35), lineWidth: 1)
                                ) //shadow
                                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 8)
                                
                            } //end of NavigationLink, everything below modifies style of what was inside it:
                            
                            .buttonStyle(.plain) //removes default SwiftUI button styling
                            
                        } //end of ForEach loop defining the tappable resource buttons
                         
                        Divider() //line and space
                        
                        Button { //button for Disclaimer View
                            showingDisclaimer = true //within this button, when tapped, set the @State variable above to true... as its state it controls the UI to show the disclaimer below.
                        } label: { //text / icon shown on the button itself defined:
                            HStack(spacing: 8) { //HStack, elements within are left to right
                                
                                Image(systemName: "exclamationmark.triangle.fill") //icon
                                    .foregroundStyle(.white) //modifiers
                                
                                Text("View Disclaimer") //text
                                    .bold() //modifiers
                                    .foregroundStyle(.white)
                            } //end of HStack holding the title ad icon inside the button. Modifiers that apply to everything within are:
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .padding(.horizontal)
                        } //end of label sectino of button definition, everything within it has the modifiers:
                        .buttonStyle(.glassProminent)
                        .tint(.red)
                        .sheet(isPresented: $showingDisclaimer) {
                            DisclaimerView() //what view is shown when $showingDisclaimer is true
                        }
                        .padding()
                        
                    } //end of VStack
                } //end of ScrollView, with everything inside having modifier:
                .padding()
                
            } //end of NavigationStack, modifiers for style below:
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
            ) //end of .background modifier
            
        } //end of AppShell
        
    } //end of body View
    
} //end of ResourceHomeView


#Preview {
    ResourceHomeView()
}
