//
//  LocalAuthentication.swift
//  MindfulCheckInApp
//
//  Created by Shane Bunting on 24/03/2026.
//
// Core API implementation for passcode, biometric lock

import Foundation
import LocalAuthentication

func authenticate(reason: String, completion: @escaping (Bool) -> Void) {
    let context = LAContext()
    var error: NSError?

    // Biometrics or passcode
    let policy: LAPolicy = .deviceOwnerAuthentication //falls back to passcode if biometrics fails, system handles FaceID/TouchID/Passcode because of this

    guard context.canEvaluatePolicy(policy, error: &error) else {
        completion(false)
        return
    }

    context.evaluatePolicy(policy, localizedReason: reason) { success, _ in
        DispatchQueue.main.async {
            completion(success)
        }
    }
}
