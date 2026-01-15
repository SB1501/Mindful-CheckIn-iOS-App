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
    @State private var showSummary = false //prevents navigation from going backwards when done

    
    var body: some View {
        ZStack {
            // Full-screen background color
            (manager.currentIndex < manager.questions.count
             ? manager.questions[manager.currentIndex].topic.backgroundColor
             : Color.clear)
            .ignoresSafeArea()
            
            // content column
            VStack {
                
                Group {
                    if manager.questions.isEmpty {
                        // Loading state while questions are being loaded
                        VStack(spacing: 16) {
                            ProgressView("Loading questions…")
                            Text("Preparing your check-in")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if manager.currentIndex < manager.questions.count {
                        let question = manager.questions[manager.currentIndex]
                        
                        //TOP HALF for question only and its positioning / style
                        VStack {
                            Spacer()
                            Text(question.title)
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 32)
                                .frame(maxWidth: 400)
                            
                            Spacer()
                        } //end of question zone
                        .frame(maxHeight: .infinity)
                        
                        // MIDDLE - input controls position and styling
                        VStack {
                            SurveyInputView(
                                question: question,
                                onAnswer: { answer in
                                    manager.recordResponse(for: question, answer: answer)
                                    answeredQuestionIDs.insert(question.id)
                                    currentQuestionAnswered = true
                                }
                            )
                        }
                        .padding(70)
                        //end of controls zone
                        
                        //LOWER - resource and navigation styling / position
                        VStack {
                            Button {
                                resourceTopicToShow = question.topic
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "book")
                                    Text("Learn more about \(question.topic.displayName)")
                                }
                            }
                            .font(.footnote.weight(.semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(.ultraThinMaterial)
                            )
                            Spacer()
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
                                .buttonStyle(.glassProminent)
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
                                .buttonStyle(.glassProminent)
                                
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
                                .buttonStyle(.glassProminent)
                                .disabled(!currentQuestionAnswered)
                            }
                            
                            .padding( 70 )
                            //end of lower zone
                        }
                        
                        
                        ProgressDotsView(current: manager.currentIndex, total: manager.questions.count)
                            .padding(.bottom, 12)
                        
                    } else {
                        // Build a session when the survey is complete using accumulated scoring
                        let session = manager.generateSession()

                        VStack(spacing: 24) {
                            // Hidden link that activates when the button is tapped
                            NavigationLink(isActive: $showSummary) {
                                SurveySummaryView(
                                    session: session,
                                    questions: manager.questions,
                                    onFinish: {
                                        // Pop summary, then dismiss the survey flow back to Main Menu
                                        showSummary = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                            dismiss()
                                        }
                                    },
                                    onDelete: {
                                        // Pop summary, then dismiss the survey flow back to Main Menu
                                        showSummary = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                            dismiss()
                                        }
                                    }
                                )
                                .navigationBarBackButtonHidden(true)
                            } label: {
                                EmptyView()
                            }

                            Spacer()

                            // Framed emoji to match the app's visual style
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1)
                                    )
                                Text("📋")
                                    .font(.system(size: 56))
                                    .accessibilityHidden(true)
                            }

                            VStack(spacing: 8) {
                                Text("Ready to review")
                                    .font(.title2).bold()
                                Text("See your check-in summary")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)

                            Button {
                                showSummary = true
                            } label: {
                                HStack(spacing: 8) {
                                    Text("View Summary")
                                        .font(.headline)
                                    Image(systemName: "chevron.right")
                                        .font(.headline)
                                }
                            }
                            .frame(maxWidth: 320)
                            .buttonStyle(.glassProminent)
                            .accessibilityLabel("View your check-in summary")

                            Spacer()
                        }
                        .padding(32)
                    }
                }
            }
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
                    if showSummary {
                        // When in summary, do nothing (no back navigation)
                        return
                    } else {
                        // Allow discarding from questions and the end screen
                        showDiscardAlert = true
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .accessibilityLabel("Close")
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

struct SurveyFlowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SurveyFlowView()
        }
    }
}

