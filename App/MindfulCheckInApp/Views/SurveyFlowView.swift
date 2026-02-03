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
    @Environment(\.horizontalSizeClass) private var hSize //for scaling and screen size changes
    private var isCompact: Bool { hSize == .compact } //for scaling and screen size changes
    @State private var showDiscardAlert = false
    @State private var resourceTopicToShow: QuestionTopic? = nil
    @State private var showSummary = false //prevents navigation from going backwards when done
    @State private var wiggle = false

    
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
                        
                        VStack(spacing: 0) {
                        
                        //TOP HALF for question only and its positioning / style
                        VStack {
                            Spacer()
                            Text(question.title)
                                .font(isCompact ? .title : .largeTitle) //based on screen size instead of one scale hard wired
                                .lineLimit(nil)
                                .minimumScaleFactor(0.9) // allow a tiny squeeze if needed
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, isCompact ? 16 : 12)
                                .frame(maxWidth: isCompact ? 320 : 700)
                            
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
                            .frame(maxWidth: isCompact ? 320 : 600)
                        }
                        .padding(.horizontal, isCompact ? 16 : 12)
                        .padding(.vertical, isCompact ? 16 : 24)
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
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(question.topic.darkerTint.opacity(0.8), lineWidth: 1)
                            )
                            .foregroundStyle(question.topic.darkerTint)
                            .tint(question.topic.darkerTint)
                            
                            Spacer()
                            
                            if !currentQuestionAnswered {
                                HStack(spacing: 6) {
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                        .opacity(0.8)
                                    Text("Make a selection to continue")
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                }
                                .rotationEffect(.degrees(wiggle ? 2 : 0))
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.1).repeatCount(4, autoreverses: true), value: wiggle)
                                .animation(.easeInOut(duration: 0.25), value: currentQuestionAnswered)
                            }
                            
                            HStack(spacing: 12) {
                                Button("Back") {
                                    // Move to previous question if possible
                                    if manager.currentIndex > 0 {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            manager.currentIndex -= 1
                                        }
                                        let q = manager.questions[manager.currentIndex]
                                        currentQuestionAnswered = answeredQuestionIDs.contains(q.id)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .buttonStyle(.glassProminent)
                                .tint((manager.currentIndex < manager.questions.count ? manager.questions[manager.currentIndex].topic.darkerTint : Color.accentColor))
                                .disabled(manager.currentIndex == 0)
                                .opacity(manager.currentIndex == 0 ? 0.5 : 1.0)
                                
                                Button("Skip") {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        manager.skipQuestion()
                                    }
                                    if manager.currentIndex < manager.questions.count {
                                        let q = manager.questions[manager.currentIndex]
                                        currentQuestionAnswered = answeredQuestionIDs.contains(q.id)
                                    } else {
                                        currentQuestionAnswered = false
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .buttonStyle(.glassProminent)
                                .tint((manager.currentIndex < manager.questions.count ? manager.questions[manager.currentIndex].topic.darkerTint : Color.accentColor))
                                
                                Button("Next") {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        manager.advance()
                                    }
                                    if manager.currentIndex < manager.questions.count {
                                        let q = manager.questions[manager.currentIndex]
                                        currentQuestionAnswered = answeredQuestionIDs.contains(q.id)
                                    } else {
                                        currentQuestionAnswered = false
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .buttonStyle(.glassProminent)
                                .tint((manager.currentIndex < manager.questions.count ? manager.questions[manager.currentIndex].topic.darkerTint : Color.accentColor))
                                .disabled(!currentQuestionAnswered)
                                .overlay(
                                    Group {
                                        if !currentQuestionAnswered {
                                            Rectangle()
                                                .fill(Color.clear)
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                    wiggle = false
                                                    DispatchQueue.main.async {
                                                        wiggle = true
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                                                            wiggle = false
                                                        }
                                                    }
                                                }
                                        }
                                    }
                                )
                            }
                            .controlSize(isCompact ? .small : .regular) //dynamic sizes
                            .padding(.horizontal, isCompact ? 16 : 12)
                            .padding(.vertical, isCompact ? 16 : 24)
                            .frame(maxWidth: isCompact ? 320 : 600)
                            //end of lower zone
                        }
                        
                        
                        ProgressDotsView(current: manager.currentIndex, total: manager.questions.count)
                            .padding(.bottom, 12)
                        }
                        .transition(.opacity)
                        .id(manager.currentIndex)

                    } else {
                        // Build a session when the survey is complete using accumulated scoring
                        let session = manager.generateSession()

                        VStack(spacing: 28) {
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

                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 140, height: 140)
                                    .overlay(
                                        Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1)
                                    )
                                Image(systemName: "checkmark.rectangle.stack.fill")
                                    .font(.system(size: 64))
                                    .accessibilityHidden(true)
                            }

                            VStack(spacing: 8) {
                                Text("Ready to review")
                                    .font(.largeTitle).bold()
                                Text("See your check-in summary")
                                    .font(.title3)
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
                                .padding(.vertical, 12)
                                .padding(.horizontal, 18)
                            }
                            .frame(maxWidth: 360)
                            .buttonStyle(.glassProminent)
                            .accessibilityLabel("View your check-in summary")

                            Spacer(minLength: 20)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.top, isCompact ? 40 : 80)
                        .padding(.horizontal, isCompact ? 20 : 40)
                        .padding(.bottom, 24)                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 115/255, green: 255/255, blue: 255/255),
                                    Color(red: 0/255, green: 251/255, blue: 207/255)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .opacity(0.36)
                            .blendMode(.plusLighter)
                            .ignoresSafeArea()
                        )
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
                if !currentQuestionAnswered {
                    wiggle = false
                    DispatchQueue.main.async {
                        wiggle = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                            wiggle = false
                        }
                    }
                }
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
                    Image(systemName: "xmark")
                        .foregroundStyle((manager.currentIndex < manager.questions.count ? manager.questions[manager.currentIndex].topic.darkerTint : Color.primary))
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
            .tint(topic.darkerTint)
        }
    }
    
}
