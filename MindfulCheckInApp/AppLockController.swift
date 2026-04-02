import Foundation
import Combine
import LocalAuthentication

final class AppLockController: ObservableObject {
    // Indicates whether the app is currently locked
    @Published var isLocked: Bool = false

    // Optional: expose a published error message or state in future

    // Lock the app (present the lock screen)
    func lock() {
        if !isLocked {
            isLocked = true
        }
    }

    // Unlock the app (dismiss the lock screen)
    func unlock() {
        if isLocked {
            isLocked = false
        }
    }

    // Attempt biometric or device passcode authentication and unlock on success
    func requestUnlock() {
        let context = LAContext()
        var error: NSError?

        // Prefer biometrics with passcode fallback
        let policy: LAPolicy = .deviceOwnerAuthentication

        guard context.canEvaluatePolicy(policy, error: &error) else {
            // If we cannot evaluate, fall back to simply unlocking to avoid trapping the user
            // You may want to handle this differently (e.g., show an error UI)
            unlock()
            return
        }

        let reason = "Unlock to continue"
        context.evaluatePolicy(policy, localizedReason: reason) { success, _ in
            if success {
                DispatchQueue.main.async {
                    self.unlock()
                }
            }
        }
    }
}
