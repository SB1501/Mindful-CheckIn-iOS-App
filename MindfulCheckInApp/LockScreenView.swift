//
//  LockScreenView.swift
//  MindfulCheckInApp
//
//  Created by Shane Bunting on 24/03/2026.
//
// View displayed when app is locked
//

import SwiftUI

struct LockScreenView: View {
    let onUnlock: () -> Void
    let onRequestUnlock: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundStyle(.white)
                Text("Unlock to Continue")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Tap anywhere to authenticate")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(24)
        }
        // Make the whole screen act like a button to retry auth
        .contentShape(Rectangle())
        .onTapGesture {
            onRequestUnlock()
        }
        // Also provide an explicit button for accessibility
        .overlay(alignment: .bottom) {
            Button(action: onRequestUnlock) {
                Text("Try Again")
                    .font(.body.bold())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.white)
                    .foregroundStyle(.black)
                    .clipShape(Capsule())
                    .padding(.bottom, 40)
            }
            .accessibilityIdentifier("LockScreenTryAgainButton")
        }
    }
}



