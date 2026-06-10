import SwiftUI

@main
struct MindfulCheckInApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("appLockEnabled") private var appLockEnabled: Bool = false
    @StateObject private var appLock = AppLockController()

    var body: some Scene {
        WindowGroup {
            ZStack {
                WelcomeView() // Your existing root content
                    .tint(Color.appAccent)
                    .preferredColorScheme(.dark)
            }
            // Present the lock above everything when needed
            .fullScreenCover(isPresented: $appLock.isLocked) {
                LockScreenView {
                    appLock.requestUnlock()
                } onRequestUnlock: {
                    appLock.requestUnlock()
                }
            }
            // Lock on cold start if enabled
            .onAppear {
                if appLockEnabled { appLock.lock() }
            }
            .onAppear {
                #if DEBUG
                let args = ProcessInfo.processInfo.arguments
                if args.contains("-RESET_DATA") {
                    SurveyStore.shared.removeAll()
                }
                if args.contains("-SEED_DUMMY_DATA") {
                    DevSeeder.seedDummyData(count: 120, overwrite: false)
                }
                #endif
            }
            // lock earlier so the app switcher snapshot shows the lock UI
            .onChange(of: scenePhase) { _, newPhase in
                if (newPhase == .inactive || newPhase == .background), appLockEnabled {
                    appLock.lock()
                }
            }
        }
    }
}
