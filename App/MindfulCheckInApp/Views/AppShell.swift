import SwiftUI

struct AppShell<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            AbstractBackgroundView(
                circleCount: 5,
                blurRadius: 80,
                seed: 42
            )
            .ignoresSafeArea()

            content()
        }
    }
}

#if DEBUG
#Preview {
    AppShell {
        VStack {
            Text("Hello, AppShell")
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
        }
        .padding()
    }
}
#endif

