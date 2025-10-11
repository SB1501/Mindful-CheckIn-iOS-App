// SB - SurveyFlowView
// Frame for the questions during a survey. hosts SurveyInputView (actual controls) and end of survey question flow. 

import Foundation
import SwiftUI

struct SurveyFlowView: View {
    @StateObject private var manager = SurveyManager()
    @State private var currentQuestionAnswered = false
    @State private var answeredQuestionIDs: Set<UUID> = []

    var body: some View {
        VStack(spacing: 30) {
            if manager.currentIndex < manager.questions.count {
                let question = manager.questions[manager.currentIndex]
                Text(question.title)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()

                VStack(spacing: 12) {
                    SurveyInputView(question: question) { answer in
                        manager.recordResponse(for: question, answer: answer)
                        answeredQuestionIDs.insert(question.id)
                        currentQuestionAnswered = true
                    }

                    if !currentQuestionAnswered {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                                .opacity(0.8)
                            Text("Make a selection to continue")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    HStack(spacing: 12) {
                        Button("Back") {
                            manager.goBack()
                            if manager.currentIndex < manager.questions.count {
                                let q = manager.questions[manager.currentIndex]
                                currentQuestionAnswered = answeredQuestionIDs.contains(q.id)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.bordered)
                        .disabled(manager.currentIndex == 0)

                        Button("Skip") {
                            manager.skipQuestion()
                            if manager.currentIndex < manager.questions.count {
                                let q = manager.questions[manager.currentIndex]
                                answeredQuestionIDs.remove(q.id)
                            }
                            currentQuestionAnswered = false
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.bordered)

                        Button("Next") {
                            manager.advance()
                            if manager.currentIndex < manager.questions.count {
                                let q = manager.questions[manager.currentIndex]
                                currentQuestionAnswered = answeredQuestionIDs.contains(q.id)
                            } else {
                                currentQuestionAnswered = false
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                        .disabled(!currentQuestionAnswered)
                    }
                }
                .frame(maxWidth: 520)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 48)

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
        .onChange(of: manager.currentIndex) { _, _ in
            if manager.currentIndex < manager.questions.count {
                let q = manager.questions[manager.currentIndex]
                currentQuestionAnswered = answeredQuestionIDs.contains(q.id)
            } else {
                currentQuestionAnswered = false
            }
        }
    }
}

