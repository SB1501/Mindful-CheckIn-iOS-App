// SB - SurveyInputView
// Handles the slider and buttons for collecting input during survey view. 

import Foundation
import SwiftUI

struct SurveyInputView: View {
    let question: SurveyQuestion
    let onAnswer: (AnswerValue) -> Void

    @State private var sliderValue: Double = 3
    @State private var selectedChoice: String?

    var body: some View {
        Group {
            switch question.inputType {
            case .slider:
                VStack {
                    Slider(value: $sliderValue, in: 1...5, step: 1, onEditingChanged: { isEditing in
                        if !isEditing {
                            onAnswer(.scale(Int(sliderValue)))
                        }
                    })
                    Text("Selected: \(Int(sliderValue))")
                }

            case .buttonGroup:
                VStack(spacing: 10) {
                    if let choices = question.options {
                        ForEach(choices, id: \.self) { choice in
                            Button(choice) {
                                selectedChoice = choice
                                onAnswer(.choice(choice))
                            }
                            .buttonStyle(.borderedProminent)
                            .background(selectedChoice == choice ? Color.blue.opacity(0.2) : Color.clear)
                        }

                    } else {
                        Text("No options available")
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: 600, alignment: .center)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
