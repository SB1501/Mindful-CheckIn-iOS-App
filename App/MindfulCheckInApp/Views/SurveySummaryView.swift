// SB - SurveySummaryView
// Controls the view of the end of survey for a summary of topics 'good' 'neutral' and 'bad' and reflection note input

import SwiftUI

struct SurveySummaryView: View {
    let session: SurveySession
    let questions: [SurveyQuestion]
    var onFinish: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil
    
    @State private var reflectionNote: String = ""
    @State private var isSaved = false
    @Environment(\.dismiss) private var dismiss //assists in ending flow / summary session
    @State private var showDiscardAlert = false //warning before deleting survey and going to menu
    @State private var showScrollPrompt = true //little scroll icon to prompt users to scroll down to finish survey
    @FocusState private var isReflectionFocused: Bool //for the reflection note 'done' button control to put keyboard away
    @Environment(\.colorScheme) private var colorScheme
    
    //to avoid initialisation errors
    var flaggedTopics: [QuestionTopic] {
        Array(session.flaggedTopics)
    }
    
    var positiveTopics: [QuestionTopic] {
        Array(session.positiveTopics)
    }
    
    var neutralTopics: [QuestionTopic] {
        Array(session.neutralTopics)
    }
    
    var skippedTopics: [QuestionTopic] {
        let skippedIDs = Set(session.responses.filter { $0.wasSkipped }.map { $0.questionID })
        return questions.filter { skippedIDs.contains($0.id) }.map { $0.topic }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 115/255, green: 255/255, blue: 255/255),
                    Color(red: 0/255, green: 251/255, blue: 207/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(colorScheme == .light ? 0.44 : 0.36)
            .blendMode(colorScheme == .light ? .overlay : .plusLighter)
            .ignoresSafeArea()

            AppShell {
                ScrollViewReader { proxy in //for the floating circle scroll prompt
                    ScrollView {
                        VStack(spacing: 20) {
                            Image(systemName: "checkmark.rectangle.stack.fill")
                                .font(.system(size: 64))
                                .accessibilityHidden(true)
                            Text("Check-In Summary")
                                .font(.title)
                                .bold()

                            // Reflection Note
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(.ultraThinMaterial)
                                            .frame(width: 32, height: 32)
                                            .overlay(Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1))
                                        Image(systemName: "pencil").font(.subheadline)
                                    }
                                    Text("Add a Reflection Note?")
                                        .font(.headline)
                                }
                                TextField("Write a quick note...", text: $reflectionNote, axis: .vertical)
                                    .textFieldStyle(.plain)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.thinMaterial)
                                    )
                                    .focused($isReflectionFocused)       // bind focus state from top to text field
                                    .submitLabel(.done)                  // show done on the keyboard
                                    .onSubmit {                          // dismiss on submit if scroll to bottom and finish & save is pressed
                                        isReflectionFocused = false
                                    }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.thinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                            )

                            // Flagged Topics
                            if !flaggedTopics.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("🔴 Things to be Mindful of")
                                        .font(.title3)
                                        .fontWeight(.semibold)

                                    ForEach(Array(flaggedTopics.enumerated()), id: \.offset) { pair in
                                        let topic = pair.element
                                        NavigationLink(destination: ResourceView(topic: topic)) {
                                            HStack(alignment: .center, spacing: 12) {
                                                ZStack {
                                                    Circle()
                                                        .fill(.ultraThinMaterial)
                                                        .frame(width: 32, height: 32)
                                                        .overlay(Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1))
                                                    Text("🔴").font(.subheadline)
                                                }
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(topic.displayName)
                                                        .font(.headline)
                                                        .fontWeight(.semibold)
                                                    Text(topic.flaggedSummary)
                                                        .font(.subheadline)
                                                        .foregroundStyle(.secondary)
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .foregroundStyle(.secondary)
                                            }
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(.thinMaterial)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.vertical)
                            }

                            // Neutral Topics
                            if !neutralTopics.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("🟡 Things you're doing okay on")
                                        .font(.title3)
                                        .fontWeight(.semibold)

                                    ForEach(Array(neutralTopics.enumerated()), id: \.offset) { pair in
                                        let topic = pair.element
                                        NavigationLink(destination: ResourceView(topic: topic)) {
                                            HStack(alignment: .center, spacing: 12) {
                                                ZStack {
                                                    Circle()
                                                        .fill(.ultraThinMaterial)
                                                        .frame(width: 32, height: 32)
                                                        .overlay(Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1))
                                                    Text("🟡").font(.subheadline)
                                                }
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(topic.displayName)
                                                        .font(.headline)
                                                        .fontWeight(.semibold)
                                                    Text(topic.neutralSummary)
                                                        .font(.subheadline)
                                                        .foregroundStyle(.secondary)
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .foregroundStyle(.secondary)
                                            }
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(.thinMaterial)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.vertical)
                            }

                            
                            // Positive Topics
                            if !positiveTopics.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("🟢 Things you're doing well on")
                                        .font(.title3)
                                        .fontWeight(.semibold)

                                    ForEach(Array(positiveTopics.enumerated()), id: \.offset) { pair in
                                        let topic = pair.element
                                        NavigationLink(destination: ResourceView(topic: topic)) {
                                            HStack(alignment: .center, spacing: 12) {
                                                ZStack {
                                                    Circle()
                                                        .fill(.ultraThinMaterial)
                                                        .frame(width: 32, height: 32)
                                                        .overlay(Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1))
                                                    Text("🟢").font(.subheadline)
                                                }
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(topic.displayName)
                                                        .font(.headline)
                                                        .fontWeight(.semibold)
                                                    Text(topic.positiveSummary)
                                                        .font(.subheadline)
                                                        .foregroundStyle(.secondary)
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .foregroundStyle(.secondary)
                                            }
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(.thinMaterial)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.vertical)
                            }

                            // Skipped Questions
                            if !skippedTopics.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Questions you skipped")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    ForEach(Array(skippedTopics.enumerated()), id: \.offset) { pair in
                                        let topic = pair.element
                                        HStack(alignment: .center, spacing: 12) {
                                            ZStack {
                                                Circle()
                                                    .fill(.ultraThinMaterial)
                                                    .frame(width: 32, height: 32)
                                                    .overlay(Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1))
                                                Text("✕").font(.subheadline)
                                            }
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(topic.displayName)
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                Text("Skipped")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                            }
                                            Spacer()
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(.thinMaterial)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                                        )
                                    }
                                }
                                .padding(.vertical)
                            }
                            
                            
                            //BUTTONS
                            if !isSaved {
                                VStack(spacing: 16) {
                                    Button {
                                        saveSession()
                                        isSaved = true
                                        onFinish?()
                                    } label: {
                                        HStack(spacing: 10) {
                                            Image(systemName: "checkmark.circle.fill")
                                            Text("Finish & Save")
                                        }
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.glassProminent)

                                    Button {
                                        showDiscardAlert = true
                                    } label: {
                                        HStack(spacing: 10) {
                                            Image(systemName: "trash")
                                            Text("Discard Check-In")
                                        }
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.red)
                                }
                                .frame(maxWidth: .infinity)
                                .controlSize(.large)
                            }
                            
                            // Invisible anchor at the very bottom to scroll to
                            Color.clear
                                .frame(height: 1)
                                .id("bottom")
                        }
                        .frame(maxWidth: .infinity, alignment: .top)
                        .padding()
                    }
                    .overlay(alignment: .bottom) { //scroll prompt circle at bottom of screen properties
                        if showScrollPrompt && !isSaved {
                            Button {
                                withAnimation(.easeInOut) {
                                    proxy.scrollTo("bottom", anchor: .bottom)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    withAnimation(.spring()) { showScrollPrompt = false }
                                }
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.down")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Scroll to finish")
                                        .font(.headline)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule(style: .continuous)
                                        .fill(.ultraThinMaterial)
                                )
                                .overlay(
                                    Capsule(style: .continuous)
                                        .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                                )
                                .shadow(radius: 8, y: 4)
                                .padding(.bottom, 16)
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.plain)
                            .transition(.scale.combined(with: .opacity))
                            .onAppear {
                                // Auto-hide after a few seconds if not interacted with
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                    if showScrollPrompt {
                                        withAnimation(.easeInOut) {
                                            showScrollPrompt = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            isReflectionFocused = false
                        }
                    }
                }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if reflectionNote.isEmpty, let note = session.reflectionNote {
                reflectionNote = note
            }
        }
        .alert("Discard this check-in?", isPresented: $showDiscardAlert) {
            Button("Cancel", role: .cancel) {}

            Button("Discard", role: .destructive) {
                isSaved = true // hides button
                onDelete?()
            }
        } message: {
            Text(reflectionNote.isEmpty ? "This check-in will not be saved." : "This check-in and your reflection note will not be saved.")
        }
    }

    
    func saveSession() {
        let summary = SurveySummary(
            good: session.positiveTopics.count,
            neutral: session.neutralTopics.count,
            bad: session.flaggedTopics.count
        )
        
        let record = SurveyRecord(
            date: session.date,
            summary: summary,
            reflection: reflectionNote,
            positiveTopics: session.positiveTopics,
            neutralTopics: session.neutralTopics,
            flaggedTopics: session.flaggedTopics
        )
        
        SurveyStore.shared.add(record)
    }
    
}

