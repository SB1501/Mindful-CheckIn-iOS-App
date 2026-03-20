//SB MINDFUL CHECK IN
// This is the wrapper which gives an app-wide background and renders content passed into it.
// AppShell means we pass the same parameters specified once here to every part of the app that calls it, rather than passing in an AbstractBackgroundView with parameters every single time - easier to change

import SwiftUI

struct AppShell<Content: View>: View {
    @ViewBuilder let content: () -> Content //this allows any SwiftUI View Hierarchy inside of it

    var body: some View {
        ZStack { //ZStack facilitates layering things on front and behind of one another
            AbstractBackgroundView( //this is the class that defines the circles and the spec of each blob / blue... it requires the below:
                circleCount: 5, //...number of circles
                blurRadius: 80, //...blur
                seed: 42 //...a passed seed
            )
            .ignoresSafeArea() //this modifier allows it to fill the entire screen

            content() //this is where the passed content sits on top since this is a ZStack, in the order top to here
        }
    }
}


#if DEBUG
private struct AppShellPreviewHost: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        AppShell {
            VStack {
                Text("Hello, AppShell")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
            }
            .padding()
        }
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

#Preview("AppShell – Dark") {
    AppShellPreviewHost().preferredColorScheme(.dark)
}
#endif
