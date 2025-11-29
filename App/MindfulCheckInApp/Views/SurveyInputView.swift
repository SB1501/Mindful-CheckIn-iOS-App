// SB - SurveyInputView
// Handles the slider and buttons for collecting input during survey view. 

import Foundation
import SwiftUI

struct SurveyInputView: View {
    let question: SurveyQuestion
    let onAnswer: (AnswerValue) -> Void

    @State private var sliderValue: Double = 3
    @State private var selectedChoice: String?
    
    private func sliderTint(for value: Int, higherIsBetter: Bool) -> Color {
        if higherIsBetter {
            switch value {
            case ..<2: return .red
            case 2: return .orange
            case 3: return .yellow
            case 4: return .green.opacity(0.8)
            default: return .green
            }
        } else {
            // Reverse mapping when higher values are worse
            switch value {
            case ..<2: return .green
            case 2: return .green.opacity(0.8)
            case 3: return .yellow
            case 4: return .orange
            default: return .red
            }
        }
    }

    private struct AccessibleScaleValue {
        let intValue: Int
        var description: String {
            switch intValue {
            case 1: return "Very low"
            case 2: return "Low"
            case 3: return "Medium"
            case 4: return "High"
            case 5: return "Very high"
            default: return "Unknown"
            }
        }
    }

    var body: some View {
        Group {
            switch question.inputType {
            case .slider:
                VStack(spacing: 20) {
                    Spacer(minLength: 0)
                    VStack(spacing: 16) {
                        let higherIsBetter = question.scoring?.higherIsBetter ?? true
                        let gradientColors: [Color] = higherIsBetter
                            ? [Color.red.opacity(0.75), Color.yellow.opacity(0.75), Color.green.opacity(0.75)]
                            : [Color.green.opacity(0.75), Color.yellow.opacity(0.75), Color.red.opacity(0.75)]

                        // Gradient track background behind the slider
                        ZStack {
                            LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
                                .frame(height: 12)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                                )

                            // Native slider on top (transparent track, thicker height via padding)
                            Slider(value: $sliderValue, in: 1...5, step: 1, onEditingChanged: { isEditing in
                                if !isEditing {
                                    onAnswer(.scale(Int(sliderValue)))
                                }
                            })
                            .tint(sliderTint(for: Int(sliderValue), higherIsBetter: higherIsBetter))
                            .padding(.vertical, 8) // visual thickness
                            .accessibilityLabel("How are you feeling scale")
                            .accessibilityValue(AccessibleScaleValue(intValue: Int(sliderValue)).description)
                        }
                        .padding(.horizontal, 12)
                        .frame(maxWidth: 420)

                        // Optional end labels for context instead of a number
                        HStack {
                            Text("Low").font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
                            Spacer()
                            Text("High").font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: 420)
                    }
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .center)

            case .buttonGroup:
                VStack(spacing: 22) {
                    Spacer(minLength: 0)
                    VStack(spacing: 18) {
                        if let choices = question.options, !choices.isEmpty {
                            // Ensure we only show up to 4 segments (pad or trim as needed)
                            let segments = Array(choices.prefix(4))

                            ZStack {
                                // Gradient pill background
                                LinearGradient(
                                    colors: [
                                        Color.red.opacity(0.85),
                                        Color.orange.opacity(0.85),
                                        Color.yellow.opacity(0.85),
                                        Color.green.opacity(0.85)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(height: 52)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                                )

                                // Segment dividers
                                HStack(spacing: 0) {
                                    ForEach(0..<segments.count, id: \.self) { idx in
                                        Rectangle()
                                            .fill(Color.clear)
                                            .overlay(
                                                idx < segments.count - 1 ?
                                                    Rectangle()
                                                        .fill(Color.white.opacity(0.25))
                                                        .frame(width: 1)
                                                : nil,
                                                alignment: .trailing
                                            )
                                    }
                                }
                                .clipShape(Capsule())

                                // Tap targets and labels
                                HStack(spacing: 0) {
                                    ForEach(segments, id: \.self) { choice in
                                        Button(action: {
                                            selectedChoice = choice
                                            onAnswer(.choice(choice))
                                        }) {
                                            Text(choice)
                                                .font(.subheadline.weight(.semibold))
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .contentShape(Rectangle())
                                        }
                                    }
                                }
                                .frame(height: 52)
                                .clipShape(Capsule())

                                // Selection highlight
                                if let selected = selectedChoice, let idx = segments.firstIndex(of: selected) {
                                    GeometryReader { geo in
                                        let segmentWidth = geo.size.width / CGFloat(segments.count)
                                        Capsule()
                                            .fill(Color.white.opacity(0.18))
                                            .frame(width: segmentWidth - 2, height: 46)
                                            .position(x: segmentWidth * (CGFloat(idx) + 0.5), y: geo.size.height / 2)
                                            .animation(.easeInOut(duration: 0.2), value: selectedChoice)
                                    }
                                    .allowsHitTesting(false)
                                }
                            }
                            .frame(height: 52)
                            .frame(maxWidth: 420)
                            .accessibilityElement(children: .contain)
                            .accessibilityLabel("Options")

                            // Optional helper labels under the pill for context
                            HStack {
                                Text(segments.first ?? "")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(segments.last ?? "")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 4)
                            .frame(maxWidth: 420)
                        } else {
                            Text("No options available")
                        }
                    }
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .center)

            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

