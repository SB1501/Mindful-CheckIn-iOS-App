// SB - SurveySummaryView
// Controls the view of the end of survey for a summary of topics 'good' 'neutral' and 'bad' and reflection note input

import SwiftUI

struct SurveySummaryView: View { //SurveySummaryView CLASS DEFINITION
    let session: SurveySession //stores an instance of SurveySession loaded in when end of survey calls this as a modal pop up view
    let questions: [SurveyQuestion] //stores the questions from the survey, according to the SurveyQuestion model structure
    var onFinish: (() -> Void)? = nil //optional callback when saving/finishing check-in
    var onDelete: (() -> Void)? = nil //optional callback when discarding the check-in
    
    @State private var reflectionNote: String = "" //local state for the reflectionNote field
    @State private var isSaved = false //tracks whether the session is saved or not, used to hide the finish and discard button when tapped
    
    @Environment(\.dismiss) private var dismiss //gives ability to dismiss current view
    
    @State private var showDiscardAlert = false //warning before deleting survey and going to menu
    @State private var showScrollPrompt = true //shows the little scroll icon to prompt users to scroll down to finish survey
    @FocusState private var isReflectionFocused: Bool //for the reflection note 'done' button control to put keyboard away
    @Environment(\.colorScheme) private var colorScheme //reads light or dark mode in the devices environment
    
    // topic buckets used to populate the sections below. copied from session to here, then these used to pass data into the sections below that summarise the survey
    var flaggedTopics: [QuestionTopic] {
        Array(session.flaggedTopics) //negative topics
    }
    
    var positiveTopics: [QuestionTopic] {
        Array(session.positiveTopics) //positive topics
    }
    
    var neutralTopics: [QuestionTopic] {
        Array(session.neutralTopics) //neutral topics
    }
    
    var skippedTopics: [QuestionTopic] { //skipped topics
        // Build a set of skipped question IDs for O(1) lookups
        let skippedIDs = Set(session.responses.filter { $0.wasSkipped }.map { $0.questionID }) //filters by only those with skipped topics in the session

        return questions.filter { skippedIDs.contains($0.id) }.map { $0.topic } //filters questions by their IDs and maps them to topics
    }
    
    
    var body: some View { //MAIN ON SCREEN UI VIEW
        ZStack {
            LinearGradient( //background gradient, which everything is on top of
                colors: [
                    Color(red: 115/255, green: 255/255, blue: 255/255),
                    Color(red: 0/255, green: 251/255, blue: 207/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ) //end of gradient, styling modifiers:
            .opacity(colorScheme == .light ? 0.44 : 0.36) //light/dark mode variations
            .blendMode(colorScheme == .light ? .overlay : .plusLighter) //blend effect
            .ignoresSafeArea() //fills the screen

            AppShell { //everything wrapped in AppShell for background
                ScrollViewReader { proxy in //for the floating circle scroll prompt to anchor
                    
                    ScrollView { //list view nature of SummaryView
                        
                        VStack(spacing: 20) { //vertical stack, everything within follows top to bottom
                            Image(systemName: "checkmark.rectangle.stack.fill") //icon
                                .font(.system(size: 64))
                                .accessibilityHidden(true)
                            Text("Check-In Summary") //title
                                .font(.title)
                                .bold()

                            // REFLECTION NOTE
                            
                            VStack(alignment: .leading, spacing: 12) {
                                
                                HStack(spacing: 12) { //icon, title
                                    ZStack {
                                        Circle() //circle background
                                            .fill(.ultraThinMaterial)
                                            .frame(width: 32, height: 32)
                                            .overlay(Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1))
                                        Image(systemName: "pencil").font(.subheadline) //icon on top of circle
                                    } //end of hstack for icon
                                    Text("Add a Reflection Note?")
                                        .font(.headline)
                                } //end of icon and title / text
                                
                                //still in main VSTACK within ScrollView
                                
                                TextField("Write a quick note...", text: $reflectionNote, axis: .vertical) //actual reflection note input text box, styling:
                                    .textFieldStyle(.plain)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.thinMaterial)
                                    )
                                    .focused($isReflectionFocused)       // bind focus state from top to text field
                                    .submitLabel(.done)                  // show done on the keyboard
                                    .onSubmit {                          // dismiss on submit if scroll to bottom and (finish & save is pressed)
                                        isReflectionFocused = false //set this back to unfocused
                                    }
                            } //end of VSTACK section, styling modifiers:
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.thinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                            )

                            // SECTIOPN - FLAGGED / NEGATIVE TOPICS
                            
                            if !flaggedTopics.isEmpty { //only show if not empty
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack{
                                        Text("Things to be Mindful of:")
                                            .font(.title)
                                            .fontWeight(.heavy)
                                    }
                                    
                                    ForEach(Array(flaggedTopics.enumerated()), id: \.offset) { pair in //for each topic..
                                        let topic = pair.element //when iterating, a sequence of offset Int, question topic is managed, element is the actual item from flaggedTopics at that index (different per survey being summarised)
                                        
                                        NavigationLink(destination: ResourceView(topic: topic)) { //powers tapping the actual topic itself to bring up the associated Resource modal pop up
                                            
                                            HStack(alignment: .center, spacing: 12) { //icon
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.red)
                                                        .frame(width: 36, height: 36)
                                                        .overlay(Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1))
                                                    Image(systemName: topic.symbolName)
                                                        .font(.title2)
                                                        .foregroundStyle(.white)
                                                    
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 4) { //topic name
                                                    Text(topic.displayName)
                                                        .font(.headline)
                                                        .fontWeight(.semibold)
                                                    Text(topic.flaggedSummary) //topic summary
                                                        .font(.subheadline)
                                                        .foregroundStyle(.secondary)
                                                }
                                                Spacer() //spacing (horizontal)
                                                
                                                Image(systemName: "chevron.right") //right icon on right of topic
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
                            } //end of flaggedTopic / Negative Section
                            
                            
                            // Neutral Topics - same as above
                            if !neutralTopics.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                        HStack{
                                            Text("Things you're doing okay on:")
                                                .font(.title)
                                                .fontWeight(.heavy)
                                        }
                                    ForEach(Array(neutralTopics.enumerated()), id: \.offset) { pair in
                                        let topic = pair.element
                                        NavigationLink(destination: ResourceView(topic: topic)) {
                                            HStack(alignment: .center, spacing: 12) {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.yellow)
                                                        .frame(width: 36, height: 36)
                                                        .overlay(Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1))
                                                    Image(systemName: topic.symbolName)
                                                        .font(.title2)
                                                        .foregroundStyle(.black.opacity(0.70))
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

                            
                            // Positive Topics  - same as above
                            if !positiveTopics.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack{
                                        Text("Things you're doing well on:")
                                            .font(.title)
                                            .fontWeight(.heavy)
                                    }
                                    ForEach(Array(positiveTopics.enumerated()), id: \.offset) { pair in
                                        let topic = pair.element
                                        NavigationLink(destination: ResourceView(topic: topic)) {
                                            HStack(alignment: .center, spacing: 12) {
                                                ZStack {
                                                    
                                                    Circle()
                                                        .fill(Color.green)
                                                        .frame(width: 36, height: 36)
                                                        .overlay(Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1))
                                                    Image(systemName: topic.symbolName)
                                                        .font(.title2)
                                                        .foregroundStyle(.white)
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

                            // Skipped Questions  - same as above, except no description or icon other than X, not tappable either
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
                            if !isSaved { //if not saved, show Finish & Save button
                                VStack(spacing: 16) {
                                    Button { //button definition FINISH & SAVE
                                        saveSession() //call saveSession to complete save
                                        isSaved = true
                                        onFinish?()
                                    } label: {
                                        HStack(spacing: 10) {
                                            Image(systemName: "checkmark.circle.fill")
                                            Text("Finish & Save")
                                        } //styling:
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.glassProminent)

                                    Button { //button definition DISCARD CHECK IN
                                        showDiscardAlert = true //not saved anyway unless explicitly saved above by other button
                                    } label: {
                                        HStack(spacing: 10) {
                                            Image(systemName: "trash")
                                            Text("Discard Check-In")
                                        } //styling:
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
                            
                            //invisible anchor at the very bottom to scroll to
                            Color.clear
                                .frame(height: 1)
                                .id("bottom")
                        }
                        .frame(maxWidth: .infinity, alignment: .top)
                        .padding()
                        
                    } //end of ScrollView, styling modifiers:
                    
                    .overlay(alignment: .bottom) { //scroll prompt circle at bottom of screen properties
                        //'tap to scroll' to the bottom; auto-hides after interaction or a short timeout, reminds users to scroll to get proceed buttons at bottom
                        
                        if showScrollPrompt && !isSaved {
                            
                            Button { //tapping the scroll prompt will scrollTo the bottom
                                withAnimation(.easeInOut) {
                                    proxy.scrollTo("bottom", anchor: .bottom)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { //gentle animation
                                    withAnimation(.spring()) { showScrollPrompt = false }
                                }
                            } label: { //visible label / content:
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
                            } //end of button label for scrollToBottom prompt, styling modifiers:
                            .buttonStyle(.plain)
                            .transition(.scale.combined(with: .opacity))
                            .onAppear {
                                //auto-hide after a few seconds if not interacted with, time starts after it appears:
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                    if showScrollPrompt {
                                        withAnimation(.easeInOut) { //animation
                                            showScrollPrompt = false //then set to false
                                        }
                                    }
                                }
                            } //end of onAppear for scroll to bottom view
                            
                        } //end of showScrollPrompt
                        
                    } //end of ScrollView modifiers
                    
                } //end of scrollViewReader
                
            } //end of AppShell (everything on fancy app wide background), styling modifiers:
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { //adds done button above keyboard when active, but if not focussed on , no keyboard so no 'done' on it
                            isReflectionFocused = false
                        }
                    }
                } //end of toolbar
        } //end of main VSTACK inside main body View, styling modifiers:
        .navigationBarBackButtonHidden(true) //no more back button once survey is done
        .onAppear {
            if reflectionNote.isEmpty, let note = session.reflectionNote {
                reflectionNote = note
            }
        } //once this view appears, populates the reflectionNote from the survey if available
        .alert("Discard this check-in?", isPresented: $showDiscardAlert) {
            Button("Cancel", role: .cancel) {} //controls warning for discarding check-in, cancel and go back ...

            Button("Discard", role: .destructive) { //...or destroy and leave session unsaved
                isSaved = true // hides button
                onDelete?()
            }
        } message: {
            Text(reflectionNote.isEmpty ? "This check-in will not be saved." : "This check-in and your reflection note will not be saved.") //text for warning , varies if reflectionNote is filled in or not
        }
    }


    func saveSession() { //SAVES SESSION AND REFLECTION NOTE, ADDING THIS SURVEY RECORD TO SURVEY STORE
        let summary = SurveySummary( //builds a SurveySummary object with counts of good/neutral/bad from this session:
            good: session.positiveTopics.count,
            neutral: session.neutralTopics.count,
            bad: session.flaggedTopics.count
        )
        
        let record = SurveyRecord( //creates SurveyRecord with date, summary, reflection and topic arrays from above...
            date: session.date,
            summary: summary,
            reflection: reflectionNote,
            positiveTopics: session.positiveTopics,
            neutralTopics: session.neutralTopics,
            flaggedTopics: session.flaggedTopics
        )
        
        SurveyStore.shared.add(record) //adds it to SurveyStore.shared
    }
    
}

