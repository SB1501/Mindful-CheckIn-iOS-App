// SB - ProgressDotsView
// Literally just for the little progress dots at the bottom of the survey view. 

import Foundation
import SwiftUI

struct ProgressDotsView: View {
    let current: Int
    let total: Int
    let skippedIndices: Set<Int>

    init(current: Int, total: Int, skippedIndices: Set<Int> = []) {
        self.current = current
        self.total = total
        self.skippedIndices = skippedIndices
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Fading edges overlay
            HStack { Spacer() }.frame(height: 0) // anchor for bottom alignment

            // Content with fade mask
            HStack(spacing: 8) {
                ForEach(0..<total, id: \.self) { index in
                    if index == current {
                        // Current: a slightly wider rounded line
                        Capsule()
                            .fill(Color.appAccent)
                            .frame(width: 22, height: 8)
                    } else if skippedIndices.contains(index) {
                        Text("✕")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.secondary)
                            .frame(width: 12, height: 12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: Color.black.opacity(0.0), location: 0.0),
                        .init(color: Color.black, location: 0.08),
                        .init(color: Color.black, location: 0.92),
                        .init(color: Color.black.opacity(0.0), location: 1.0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        }
    }
}

