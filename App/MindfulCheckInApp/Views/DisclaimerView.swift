// SB MINDFUL CHECK IN - DisclaimerView
// Controls the Disclaimer at the start of the app and used throughout next to anything that may be perceived as advice.

import Foundation
import SwiftUI

struct DisclaimerView: View { //declaring the SwiftUI View, conforms to the View protocol
    @AppStorage("hasCompletedNotificationSetup") private var hasCompletedNotificationSetup = false
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer: Bool = false //binds a property to UserDefaults storage, private means its scoped to this type and not viewable by other parts of the app, stores whether the user has accepted the initial disclaimer
    @Environment(\.dismiss) private var dismiss //pulls the dismiss action from the environment, provided by Swift UI for dismissing modals/sheets or popping navigation. in this case, this is presented as a modal mid survey / when viewing resource topics
    

    
    
    var body: some View { //required on every View type, returns the views hierarchy.
        ZStack { //layout container ZStack overlays children from back to front (on top of behind one another). First is back most.

            LinearGradient( //red/orange smooth gradient background colour, red to reflect urgency and importance but a gradient to  keep a smooth modern and pleasant UI
                colors: [Color.orange.opacity(0.85), Color.red.opacity(0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea() //allows filling of full screen including under the status bar / home indicator
            

            //we are still inside the ZStack above - so this next VStack sits in front of the background.
            
            VStack(spacing: 24) { //VStack so each item within goes below the last vertically, first is topmost. This spacing 24 is applied to everything inside below equally!

                ZStack { //symbol for warning triangle at top
                    Image(systemName: "exclamationmark.triangle.fill") //SF Symbols. Modifiers applied below:
                        .font(.system(size: 100, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8)
                }
                .padding(.top, 40)

                Text("Disclaimer") //Title text just sits below the last item above, since we are within the VStack subject to the 24 padding still. Modifiers applies below:
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8)

                //main text paragraph sits below, also subject to 24 spacing but with its own modifiers as needed applied to style it below:
                Text("This app is for reflection and wellbeing support. It does not act as a medical device and does not provide diagnosis or treatment. If you are experiencing distress or a medical emergency, seek professional help. By continuing to use this app, you acknowledge and accept these terms.")
            
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.95))
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 8)

                Spacer()

                Button(action: { //tappable button defined for the proceeding past the disclaimer. Action gives it an action, which is set to set the variable to true defined at the top of this class
                    hasAcceptedDisclaimer = true
                    dismiss() //initiates the SwiftUI dismiss function
                }) { //defines the text and icon within the button and associated modifiers:
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("I understand").bold()
                    }
                    .frame(maxWidth: .infinity) //makes button wide to keep consistent with others in the app
                    .padding(.vertical, 14) //keeps the button taller
                    .foregroundStyle(Color(.red)) //text colour
                }
                .buttonStyle(.glassProminent) //new liquid glass styling
                .foregroundStyle(Color(.white)) //body colour
                .padding(.horizontal) //edge padding outside button
                .tint(Color(.white)) //body colour
                .padding(.bottom)
            } //end of VStack with title/text/button
            .padding()
        } //end of ZStack
        .navigationBarBackButtonHidden(true)
    } //end of body
}


#Preview("DisclaimerView") {
    NavigationStack {
        DisclaimerView()
    }
}

