// SB - SurveyFlowView
// Frame for the questions during a survey. hosts SurveyInputView (actual controls) and end of survey question flow. 

import Foundation
import SwiftUI

extension QuestionTopic: Identifiable { //extends QuestionTopic to be Identifiable using its displayName as a unique ID, powering SwiftUI API like .sheet(item) and List to track QuestionTopic instances by identity
    public var id: String { displayName }
}

struct SurveyFlowView: View { //class definition
    
    @StateObject private var manager = SurveyManager() //creates an instance of SurveyManager which handles the data model for each survey
    @State private var currentQuestionAnswered = false //only when a selection is made is this state variable updated to change the UI next button
    @State private var answeredQuestionIDs: Set<UUID> = [] //creates an array of UUIDs belonging to each question as 'answered' used when an answer is saved
    @Environment(\.dismiss) private var dismiss //dismisses the Resource modal sheet if open
    @State private var showDiscardAlert = false //warning over quitting survey early
    @State private var resourceTopicToShow: QuestionTopic? = nil //
    @State private var showSummary = false //prevents navigation from going backwards when done
    @State private var wiggle = false //used to control wiggle animation on 'make a selection' text to quietly prompt user to make a choice to proceed

    
    var body: some View { //main on screen UI View
        ZStack { //zstack, what follows it stacked in front of one another
            // full-screen background color, changes per question
            (manager.currentIndex < manager.questions.count
             ? manager.questions[manager.currentIndex].topic.backgroundColor
             : Color.clear) //as long as the currentIndex of this instance of the survey (manager) is less than the total count of questions, then look at those questions, and the current questions index, .topic.backgroundColor property. This color is used for the background
            .ignoresSafeArea() //allows the background above to go fullscreen including the notch and home line areas on top and bottom
            
            // content column
            VStack {
                
                Group {
                    if manager.questions.isEmpty {
                        //loading state while questions are being loaded
                        VStack(spacing: 16) {
                            ProgressView("Loading questions…")
                            Text("Preparing your check-in")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if manager.currentIndex < manager.questions.count {
                        let question = manager.questions[manager.currentIndex]
                        // but if there is questions, take the current index of our SurveyManager instance, so long as it's less than the total count... and store within question the questions currentIndex
                        
                        VStack(spacing: 0) {
                        
                        //TOP HALF for question only and its positioning / style
                        VStack {
                            Spacer()
                            Text(question.title) //question text
                                .font(.title)
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 16) //space on sides of text
                                .frame(maxWidth: 600) //max width defined to start a new line
                            
                            Spacer()
                            
                        } //end of question zone, style modifier for it:
                        .frame(maxHeight: .infinity)
                        
                        // MIDDLE - input controls position and styling
                        VStack {
                            SurveyInputView( //calls the SurveyInputView (CONTROL CLUSTER) and ...
                                question: question, //...passes it the current index of our question...
                                onAnswer: { answer in //whem it's answered, calls our instance of SurveyManagers recordResponse feature for question, attaching it to answer...
                                    manager.recordResponse(for: question, answer: answer) //calling SurveyManager instances recordResponse function
                                    answeredQuestionIDs.insert(question.id) //appending this questions ID to the answeredQuestions array at the top of this class
                                    currentQuestionAnswered = true //also sets current question answered to true on selecting an answer...
                                } //end of onAnswer
                            ) //end of SurveyInputView, styling modifier:
                            .frame(maxWidth: 600)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                            
                        Spacer()
                            
                        //end of controls zone
                        
                        //LOWER - resource and navigation styling / position
                        VStack {
                            
                            Button { //resource button
                                resourceTopicToShow = question.topic //linked to current topic, when opening it from a tap
                            } label: {
                                HStack(spacing: 6) { //Hstack stacking left to right with what is inside.. defines icon and text shown
                                    Image(systemName: "book")
                                    Text("Learn more about \(question.topic.displayName)") //appends topic name to Learn more about text
                                } //end of Hstack inside label
                            } //end of label, with styling modifiers:
                            .font(.footnote.weight(.semibold)) //font
                            .padding(.horizontal, 14) //spacing inside
                            .padding(.vertical, 10) // spacing inside
                            .background( //shape of background
                                Capsule(style: .continuous)
                                    .fill(.ultraThinMaterial)
                            )
                            .overlay( //outline 
                                Capsule(style: .continuous)
                                    .stroke(question.topic.darkerTint.opacity(0.8), lineWidth: 1)
                            )
                            .foregroundStyle(question.topic.darkerTint)
                            .tint(question.topic.darkerTint)
                            
                            Spacer() //keeps input and resources up a good bit from the bottom buttons
                            
                            if !currentQuestionAnswered { //only show 'make a selection' if no answer has been tapped yet
                                HStack(spacing: 6) { //properties of that, logo and text..
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                        .opacity(0.8)
                                    Text("Make a selection to continue")
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                } //animation modifiers:
                                .rotationEffect(.degrees(wiggle ? 2 : 0))
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.1).repeatCount(4, autoreverses: true), value: wiggle)
                                .animation(.easeInOut(duration: 0.25), value: currentQuestionAnswered)
                            } //end of make a selection section
                            
                            //LOWER BUTTON area
                            
                            HStack(spacing: 12) { //each button within this horizontal stack appears to the right of the last...
                                Button("Back") { // move to previous question if possible
                                    if manager.currentIndex > 0 { //unless current index is 0, then no back option shown...
                                        withAnimation(.easeInOut(duration: 0.25)) { //animation when pressed...
                                            manager.currentIndex -= 1
                                        } //otherwise, decrement current index by 1. After moving back, fetches new current question and updates currentQuestionAnswered
                                        let q = manager.questions[manager.currentIndex]
                                        currentQuestionAnswered = answeredQuestionIDs.contains(q.id) //if this questions ID already exists in the answeredQuestionIDs so the UI can reflect if the previous question answered
                                    } //end of if statement for back button
                                } //end of Back button, styling modifiers:
                                .frame(maxWidth: .infinity)
                                .buttonStyle(.glassProminent)
                                .tint((manager.currentIndex < manager.questions.count ? manager.questions[manager.currentIndex].topic.darkerTint : Color.accentColor)) //colour tint to reflect the question topic
                                .disabled(manager.currentIndex == 0) //when the question is 0, no back option makes sense so disable it
                                .opacity(manager.currentIndex == 0 ? 0.5 : 1.0) //and also make it less visible when disabled at 0
                                
                                Button("Skip") {
                                    withAnimation(.easeInOut(duration: 0.25)) { //animation when pressed
                                        manager.skipQuestion() //when pressed, calls this instance of SurveyManagers 'skipQuestion' function
                                    }
                                    
                                    //Below handles if the question was already answered, but we've went back and now are skipping forward. The original input is preserved. We only set 'skipped' if it's not been answered yet or ever had a selection made.
                                    if manager.currentIndex < manager.questions.count { //if the current question is less than the total count then it's within bounds, so...
                                        let q = manager.questions[manager.currentIndex]
                                        currentQuestionAnswered = answeredQuestionIDs.contains(q.id) //read the q (current question ID) and check if it has already been answered, if index out of bounds, we never create q and fall into the else.
                                    } else { //if it's not already on that list, then set it to not answered as it is skipped
                                        currentQuestionAnswered = false
                                    }
                                } //end of Button Skip, styling modifiers:
                                .frame(maxWidth: .infinity)
                                .buttonStyle(.glassProminent)
                                .tint((manager.currentIndex < manager.questions.count ? manager.questions[manager.currentIndex].topic.darkerTint : Color.accentColor)) //use current topic colour as a tint
                                
                                Button("Next") {
                                    withAnimation(.easeInOut(duration: 0.25)) { //animate when pressed
                                        manager.advance() //call this instance of SurveyManagers advance method to move forward...
                                    }
                                    
                                    if manager.currentIndex < manager.questions.count { //checks if question is within bounds of the question set...
                                        let q = manager.questions[manager.currentIndex]
                                        currentQuestionAnswered = answeredQuestionIDs.contains(q.id) //if so reads answeredQuestionIDs to see if it has already been answered... so the UI knows if question is already answered or not
                                    } else {
                                        currentQuestionAnswered = false
                                    } //when currentIndex is no longer in bounds (e.g. last question) there is no current question so the state is set to false to trigger the completion screen
                                } //end of Next button, styling modifiers:
                                .frame(maxWidth: .infinity)
                                .buttonStyle(.glassProminent)
                                .tint((manager.currentIndex < manager.questions.count ? manager.questions[manager.currentIndex].topic.darkerTint : Color.accentColor)) //colour of question topic
                                .disabled(!currentQuestionAnswered) //disabled until an answer is selected
                                .overlay(
                                    Group {
                                        if !currentQuestionAnswered {
                                            Rectangle() //rectangle overlays Next button
                                                .fill(Color.clear) //see through
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                    wiggle = false
                                                    DispatchQueue.main.async { //wiggle animation by default is false... but when tapped, is true for...
                                                        wiggle = true
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { //for 0.45 seconds from now , then false..
                                                            wiggle = false
                                                        }
                                                    }
                                                }
                                        }
                                    } //end of Group
                                ) //end of Next button overlay
                            } //end of Lower Button Area, with styling modifiers:
                            .controlSize(.regular)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 20)
                            .frame(maxWidth: 600)
                            //end of lower zone
                        } //end of lower section VStack
                        
                            //WE ARE STILL WITHIN THE BIG VSTACK THAT HOLDS ALL SUB STACKS FOR TITLE , CONTROLS , BUTTONS ..
                        
                        ProgressDotsView(current: manager.currentIndex, total: manager.questions.count) //calls the ProgressDotsView class, passing current index, along with total number of questions (count of questions in system)
                            .padding(.bottom, 12)
                        }
                        .transition(.opacity) //fade transition as the current index iterates and the highlighted dot moves
                        .id(manager.currentIndex) //colours current index

                        //END OF IF FROM WHETHER OR NOT QUESTIONS LOADED
                        //BELOW IF IS WHEN CURRENT INDEX IS EQUAL TO COUNT - in other words, survey is done... so move on to this...
                        
                    } else {
                        // build a session when the survey is complete using accumulated scoring...
                        let session = manager.generateSession() //stores this instances answers into the session variable here

                        //UI ELEMENTS FOR 'READY TO REVIEW' SCREEN
                        
                        VStack(spacing: 28) { //vertical stack, all following elements within appear under the last...
                            
                            ZStack {
                                Circle() //icon and circle
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 140, height: 140)
                                    .overlay(
                                        Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1)
                                    )
                                Image(systemName: "checkmark.rectangle.stack.fill")
                                    .font(.system(size: 64))
                                    .accessibilityHidden(true)
                            }

                            VStack(spacing: 8) { //title text and description
                                Text("Ready to review")
                                    .font(.largeTitle).bold()
                                Text("See your check-in summary")
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                            }
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)

                            Button { //button to move on to SurveySummaryView
                                showSummary = true //when pressed, changes that variable. Must be true to push SurveySummaryView, as its onFinish and onDelete callback sets it to false to return the user to the main menu
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
                        } //end of Ready to Review UI, styling modifiers:
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.top, 60)
                        .padding(.horizontal, 24)
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
                        .navigationDestination(isPresented: $showSummary) { //CALLS SURVEY SUMMARY VIEW with this sessions data, which appears on top of this view... and passes it the session details to display...
                            SurveySummaryView( //passing data over to it from this survey session...
                                session: session,
                                questions: manager.questions,
                                onFinish: { //finish and save
                                    // pop summary, then dismiss the survey flow back to Main Menu
                                    showSummary = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                        dismiss()
                                    }
                                },
                                onDelete: { //finish and delete
                                    // pop summary, then dismiss the survey flow back to Main Menu
                                    showSummary = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                        dismiss()
                                    }
                                }
                            )
                            .navigationBarBackButtonHidden(true)
                        }
                    } // END OF ELSE FOR WHEN SURVEY IS DONE
                } //end of Group
           
            } //end of VSTACK with main views included for a survey
            
        } //end of zstack which starts with the full screen coloured background, further styling modifiers below:
        .navigationBarBackButtonHidden(true)
        .onAppear { //on appear of the main UI stack for SurveyFlow...
            if manager.questions.isEmpty {
                manager.loadQuestions() //triggers the loading of the questions
            }
        } //on change of current index... (any move back or next)
        .onChange(of: manager.currentIndex) { _, _ in
            if manager.currentIndex < manager.questions.count { //if currentIndex is within range...
               
                let q = manager.questions[manager.currentIndex]
                currentQuestionAnswered = answeredQuestionIDs.contains(q.id) //check if the  current question (stored in q) is in the list of already answered questions...
                
                if !currentQuestionAnswered { //if not currently answered, set wiggle to false initially (to ensure a clean trigger) but then wiggle it for 0.45s .. this is the initial animation wiggle when a new question appears (onChange)... which is then repeated for every tap of a disabled Next button when that's the case...
                    wiggle = false
                    DispatchQueue.main.async {
                        wiggle = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                            wiggle = false
                        }
                    }
                }
                
            } else {
                currentQuestionAnswered = false //if the current question is past the index of the count of question in the system, set currentQuestionAnswered to false ... coincides with when the survey is complete, keeping the UI up to date with when the survey is complete
            }
            
        } //end of the 'onChange' of question code, but we are still on modifiers of the ZStack with all of the coloured background for this view, continuing with...
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if showSummary {
                        // when in summary, do nothing (no back navigation)
                        return
                    } else {
                        // allow discarding from questions and the end screen
                        showDiscardAlert = true //doesn't show on Preview in Xcode but does show on device
                    }
                }) { //still in Button, defines 'X' and styling:
                    Image(systemName: "xmark")
                        .foregroundStyle((manager.currentIndex < manager.questions.count ? manager.questions[manager.currentIndex].topic.darkerTint : Color.primary))
                        .accessibilityLabel("Close")
                }
            }
        } //still continuing with modifiers to background coloured view area for SurveyFlowView
        .alert("Discard check-in?", isPresented: $showDiscardAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Discard", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("If you go back now, your current check-in progress will be lost.") //alert dialogue for going back mid-survey, changes variable at top of this class
        }
        .sheet(item: $resourceTopicToShow) { topic in //defines the topic shown when the Resource button for that question is pressed...
            
            NavigationStack { //handles view modal pop up using a NavigationStack
                
                ZStack {
                    topic.backgroundColor.ignoresSafeArea() //specifies background colour and full screen scope
                    ResourceView(topic: topic) //passes in the current topic which ResourceView needs to display
                }
                .toolbar { //done button on this modal pop up view
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Done") { resourceTopicToShow = nil } //sets this back to nil
                    }
                }
            }
            .tint(topic.darkerTint)
        } //end of .sheet
   
    } //END OF MAIN VIEW BODY FOR THIS SurveyFlowView Class
    
}

#Preview {SurveyFlowView()}
