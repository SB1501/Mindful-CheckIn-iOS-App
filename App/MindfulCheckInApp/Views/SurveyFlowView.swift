// SB - SurveyFlowView
// Frame for the questions during a survey. hosts SurveyInputView (actual controls) and end of survey question flow. 

import Foundation
import SwiftUI

#if canImport(SwiftUI)
extension QuestionTopic: Identifiable {
    public var id: String { displayName }
}
#endif

struct SurveyFlowView: View {
    @StateObject private var manager = SurveyManager()
    @State private var currentQuestionAnswered = false
    @State private var answeredQuestionIDs: Set<UUID> = []
    @Environment(\.dismiss) private var dismiss
    @State private var showDiscardAlert = false
    @State private var resourceTopicToShow: QuestionTopic? = nil

    var body: some View {
        ZStack {
            // Full-screen background color
            (manager.currentIndex < manager.questions.count
             ? manager.questions[manager.currentIndex].topic.backgroundColor
             : Color.clear)
                .ignoresSafeArea()

            // Existing content column
            VStack(spacing: 36) {

                if manager.currentIndex < manager.questions.count {
                    let question = manager.questions[manager.currentIndex]
                    Text(question.title)
                        .font(.system(size: 34, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .minimumScaleFactor(0.8)
                        .lineLimit(3)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: 900)
                        .frame(maxWidth: .infinity, alignment: .center)

                    VStack(spacing: 18) {
                        SurveyInputView(
                            question: question,
                            onAnswer: { answer in
                                manager.recordResponse(for: question, answer: answer)
                                answeredQuestionIDs.insert(question.id)
                                currentQuestionAnswered = true
                            }
                        )
                        
                        Button {
                            resourceTopicToShow = question.topic
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "book")
                                Text("Learn more about \(question.topic.displayName)")
                            }
                        }
                        .font(.footnote.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule(style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(question.topic.buttonTint.opacity(0.6), lineWidth: 1)
                        )
                        .foregroundStyle(.primary)
                        .tint(question.topic.buttonTint)

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
                                // Move to previous question if possible
                                if manager.currentIndex > 0 {
                                    manager.currentIndex -= 1
                                    let q = manager.questions[manager.currentIndex]
                                    currentQuestionAnswered = answeredQuestionIDs.contains(q.id)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .buttonStyle(.bordered)
                            .disabled(manager.currentIndex == 0)
                            .opacity(manager.currentIndex == 0 ? 0.5 : 1.0)

                            Button("Skip") {
                                manager.skipQuestion()
                                if manager.currentIndex < manager.questions.count {
                                    let q = manager.questions[manager.currentIndex]
                                    currentQuestionAnswered = answeredQuestionIDs.contains(q.id)
                                } else {
                                    currentQuestionAnswered = false
                                }
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
                    .frame(maxWidth: 900)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)

                    ProgressDotsView(current: manager.currentIndex, total: manager.questions.count)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                } else {
                    ZStack {
                        // Full-screen background image placeholder
                        Image("summaryBackgroundPlaceholder")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .ignoresSafeArea()
                            .clipped()
                            .overlay(Color.black.opacity(0.25))

                        VStack(spacing: 24) {
                            Spacer()
                            Text("Nice work!")
                                .font(.largeTitle.bold())
                                .foregroundStyle(.white)
                                .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)

                            NavigationLink {
                                SurveySummaryView(session: manager.generateSession(), questions: manager.questions)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "doc.plaintext")
                                    Text("View Summary")
                                }
                                .font(.title2.weight(.bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 28)
                                .padding(.vertical, 16)
                                .background(
                                    Capsule(style: .continuous)
                                        .fill(Color.accentColor.opacity(0.95))
                                )
                                .overlay(
                                    Capsule(style: .continuous)
                                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 10)
                            }
                            .buttonStyle(.plain)
                            Spacer()
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(maxWidth: 1100)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if manager.questions.isEmpty {
                manager.loadQuestions()
            }
        }
        .onChange(of: manager.currentIndex) { _, _ in
            if manager.currentIndex < manager.questions.count {
                let q = manager.questions[manager.currentIndex]
                currentQuestionAnswered = answeredQuestionIDs.contains(q.id)
            } else {
                currentQuestionAnswered = false
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if manager.currentIndex >= manager.questions.count {
                        // From summary, step back to the last question instead of jumping to the start
                        if manager.questions.count > 0 {
                            manager.currentIndex = max(0, manager.questions.count - 1)
                            let q = manager.questions[manager.currentIndex]
                            currentQuestionAnswered = answeredQuestionIDs.contains(q.id)
                        }
                    } else {
                        showDiscardAlert = true
                    }
                }) {
                    Label("Back", systemImage: "chevron.left")
                }
            }
        }
        .alert("Discard check-in?", isPresented: $showDiscardAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Discard", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("If you go back now, your current check-in progress will be lost.")
        }
        .sheet(item: $resourceTopicToShow) { topic in
            NavigationStack {
                ZStack {
                    topic.backgroundColor.ignoresSafeArea()
                    ResourceView(topic: topic)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Done") { resourceTopicToShow = nil }
                    }
                }
            }
        }
    }
}

