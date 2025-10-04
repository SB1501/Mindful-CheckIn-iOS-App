// SB - ProgressDotsView
// Literally just for the little progress dots at the bottom of the survey view. 

import Foundation
import SwiftUI

struct ProgressDotsView: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<total, id: \.self) { index in
                Circle()
                    .fill(index == current ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: 10, height: 10)
            }
        }
    }
}
