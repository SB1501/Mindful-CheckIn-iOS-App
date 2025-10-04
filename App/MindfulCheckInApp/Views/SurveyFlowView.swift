// SB - SurveyFlowView
// Frame for the questions during a survey. hosts SurveyInputView (actual controls) and end of survey question flow. 

import Foundation
import SwiftUI

struct SurveyFlowView: View {
    @StateObject private var manager = SurveyManager()

    var body: some View {
        VStack(spacing: 30) {
            if manager.currentIndex < manager.questions.count {
                let question = manager.questions[manager.currentIndex]
                Text(question.title)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()

                SurveyInputView(question: question) { answer in
                    manager.recordResponse(for: question, answer: answer)
                }

                HStack(spacing: 12) {
                    Button("Back") {
                        manager.goBack()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)

                    Button("Skip") {
                        manager.skipQuestion()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)

                    Button("Next") {
                        manager.advance()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)

                ProgressDotsView(current: manager.currentIndex, total: manager.questions.count)
            } else {
                NavigationLink("View Summary", destination:
                    SurveySummaryView(session: manager.generateSession(), questions: manager.questions)
                )
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: 600, alignment: .center)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical)
        .onAppear {
            manager.loadQuestions()
        }
    }
}
