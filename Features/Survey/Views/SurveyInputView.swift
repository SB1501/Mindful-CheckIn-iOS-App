// SB - SurveyInputView
// Handles the slider and buttons for collecting input during survey view. Reports input back using a callback.

import Foundation
import SwiftUI

struct SurveyInputView: View { //main class definition
    let question: SurveyQuestion //defines an instance of SurveyQuestion model to know to render title, input type, options and scoring
    let onAnswer: (AnswerValue) -> Void //when an answer is selected, callback so that the parent (SurveyFlowView) can record it
    
    @Environment(\.horizontalSizeClass) private var hSize //environment variable so reads something about the device its running on, in this case, the horizontal size to determine whether to use compact spacing vs regular spacing.
    private var isCompact: Bool { hSize == .compact } //checking if the environment is compact, if true, hSize .compact used)

    @State private var sliderValue: Double = 3 //default placement of control on a slider in the middle
    @State private var selectedChoice: String? //holds the selected choice for button input

    //FUNCTION - DEFINES COLOUR GRADIENT 'green good / red bad'
    private func sliderTint(for value: Int, higherIsBetter: Bool) -> Color {
        
        if higherIsBetter {
            switch value {
            case ..<2: return .red //(low/red/bad)
            case 2: return .orange
            case 3: return .yellow
            case 4: return .green.opacity(0.8)
            default: return .green //(high/green/good)
            }
            //if not higherIsBetter, assumed, lower is better..
        } else {
            // reverse mapping when higher values are worse
            switch value {
            case ..<2: return .green //(low/green/good)
            case 2: return .green.opacity(0.8)
            case 3: return .yellow
            case 4: return .orange
            default: return .red //(high/red/bad)
            }
        }
    } //end of sliderTint

    
    private struct AccessibleScaleValue { //helper struct to make accessibility more readable from a numeric scale to wording for it
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

    //MAIN ON SCREEN UI VIEW FOR THIS CLASS
    var body: some View { //defining the main view
        
        Group { //all content embodied within a Group so that the modifiers following it apply equally to everything within
            switch question.inputType { //SWITCH used to control if a slider or buttonGroup is suitable when called
            
            //SLIDER DEFINITION
            case .slider:
                VStack(spacing: 8) { //vertical stack, everything within follows top to bottom
                    let higherIsBetter = question.scoring?.higherIsBetter ?? true //defaults to higherIsBetter if nothing provided to say lower is better
                    let gradientColors: [Color] = higherIsBetter //chooses a colour gradient direction for higher is better, but if false, then reverses it
                        ? [Color.red.opacity(0.75), Color.yellow.opacity(0.75), Color.green.opacity(0.75)]
                        : [Color.green.opacity(0.75), Color.yellow.opacity(0.75), Color.red.opacity(0.75)]

                    // gradient track background BEHIND the slider
                    ZStack { //zstack so everything within sits on top of the previous in order
                        LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing) //draws the gradient as a capsule shape, with a subtle outline stroke:
                            .frame(height: CGFloat(isCompact ? 8 : 10)) //settings provided for if isCompact is not true,:and true
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
                            )

                        // Native slider on top (transparent track, thicker height via padding)
                        Slider(value: $sliderValue, in: 1...5, step: 1, onEditingChanged: { isEditing in
                            if !isEditing { //actual slider itself UI element, bound to sliverValue with 5 steps and when user stops dragging it, provides an answer via onAnswer
                                onAnswer(.scale(Int(sliderValue)))
                            }
                        }) //styling modifiers apply:
                        .tint(sliderTint(for: Int(sliderValue), higherIsBetter: higherIsBetter)) //colours the slider mid-drag based on current value and scoring direction
                        .padding(.vertical, CGFloat(isCompact ? 6 : 8)) // visual thickness
                        .accessibilityLabel("How are you feeling scale") //descriptive label for this element to read out when relevant accessibiltiy settings are on
                        .accessibilityValue(AccessibleScaleValue(intValue: Int(sliderValue)).description) //passes the value, in addition to the label above, to the accessibility settings if on
                    } //end of ZStack holding the slider and colouring overlay, styling modifiers apply:
                    .padding(.horizontal, isCompact ? 16 : 12)

                    // end labels 'Low/High' for context instead of a number
                    HStack { //hstack, everything within follows left to right
                        Text("Low").font(isCompact ? .caption2 : .caption).foregroundStyle(.secondary) //styling and sizing for the text
                        Spacer() //this spacer in between pushes each to the screen sides
                        Text("High").font(isCompact ? .caption2 : .caption).foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, isCompact ? 16 : 12)
                } //end of SLIDER VSTACK, styling modifiers:
                .controlSize(isCompact ? .small : .regular) //adapts for smaller screen sizes
                .padding(.horizontal, isCompact ? 16 : 12) //adapts for smaller screen sizes

            //BUTTON DEFINITION
            case .buttonGroup: //this case in the SWITCH is used when SurveyInputView is called with .buttonGroup
                
                VStack(spacing: 12) {
                    
                    if let choices = question.options, !choices.isEmpty { //fill choices variable with question options for that question, as long as this is not empty
                        let segments = Array(choices.prefix(4)) //only use the first four segments
                        let pillHeight: CGFloat = isCompact ? 40 : 48

                        ZStack { //Zstack, everything within follows front to back...
                            LinearGradient( //colour for background
                                colors: [
                                    Color.red.opacity(0.85),
                                    Color.orange.opacity(0.85),
                                    Color.yellow.opacity(0.85),
                                    Color.green.opacity(0.85)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ) //end of gradient, styling applies:
                            .frame(height: pillHeight)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
                            )

                            // button segment divider lines
                            HStack(spacing: 0) {
                                ForEach(0..<segments.count, id: \.self) { idx in //repeats, clear rectangles
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
                            } //end of divider HStack, styling applies:
                            .clipShape(Capsule())

                            //tap targets and labels
                            HStack(spacing: 0) {
                                ForEach(segments, id: \.self) { choice in //each sectoion is a full height and width button...
                                    Button(action: {
                                        selectedChoice = choice
                                        onAnswer(.choice(choice)) //when tapped, sets choice via onAnswer
                                    }) {
                                        Text(choice)
                                            .font(isCompact ? .footnote.weight(.semibold) : .subheadline.weight(.semibold))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .contentShape(Rectangle())
                                    }
                                }
                            } //end of HStack for each button, styling modifiers:
                            .frame(height: pillHeight)
                            .clipShape(Capsule())
                            .overlay { //the highlight overlay shown which shows which option is tapped / selected:
                                HStack(spacing: 0) {
                                    ForEach(segments.indices, id: \.self) { i in
                                        ZStack {
                                            if let selected = selectedChoice, //display logic for making sure selctedChoice is the overlay that has the lighter appearance applied to it
                                               let idx = segments.firstIndex(of: selected),
                                               idx == i {
                                                Rectangle()
                                                    .fill(Color.white.opacity(0.25))
                                                    .animation(.easeInOut(duration: 0.2), value: selectedChoice) //fade animation when tapped
                                            } else {
                                                Color.clear //if NOT selected, go clear.
                                            }
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                } //end of HSTACK inside .overlay controlling tapped option styling
                                .clipShape(Capsule())
                            } //end of overlay

                        } //end of ZSTACK inside the main VSTACK of buttonGroup, styling modifiers apply:
                        .frame(height: pillHeight)
                        .accessibilityElement(children: .contain) //groups all of the pill shapes children and labels them below..
                        .accessibilityLabel("Options")

                        // optional helper labels under the pill for context
                        HStack {
                            Text(segments.first ?? "")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(segments.last ?? "")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, isCompact ? 16 : 12)
                    } else { // second half of major IF STATEMENT, all of the above was if there were valid questions, below is IF NOT:
                        Text("No options available")
                    }
                } //end of main VSTACK inside this SWITCH

            } //end of SWITCH statement
        } //end of group, styling modifiers apply:
        .controlSize(isCompact ? .small : .regular)
        .padding(.horizontal, isCompact ? 16 : 12)
    } //end of main VIEW body
} //end of SurveyInputView class


#Preview("Button group input") {
    let sampleQuestion = SurveyQuestion(
        id: UUID(),
        title: "How much sleep have you had?",
        topic: .sleep,
        inputType: .buttonGroup,
        isEnabled: true,
        backgroundColorName: "#D8CDEA",
        options: ["None", "Low", "Some", "Plenty"],
        scoring: ScoringRule(higherIsBetter: true)
    )
    SurveyInputView(question: sampleQuestion) { _ in }
}

#Preview("Slider input") {
    let sampleQuestion = SurveyQuestion(
        id: UUID(),
        title: "Overall mood",
        topic: .sleep,
        inputType: .slider,
        isEnabled: true,
        backgroundColorName: "#CCE5FF",
        options: nil,
        scoring: ScoringRule(higherIsBetter: true)
    )
    SurveyInputView(question: sampleQuestion) { _ in }
}
