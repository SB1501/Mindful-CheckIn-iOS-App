// SB MINDFUL CHECK IN - PastRecordsView
// Allows users to look at previous Check-in Surveys to identify any common patterns.

import Foundation
import SwiftUI

//CLASS DEFINITION AND STATE VARIABLES
struct PastRecordsView: View { //new View describing the UI in this class / screen view
    @Environment(\.colorScheme) private var colorScheme //Environment variable that reads the current device environment setting for light or dark mode
    @StateObject private var store = SurveyStore.shared //Observable Object tied to the apps SurveyData
    @State private var recordToDelete: SurveyRecord? = nil //a record to be deleted, initialised to nil by default, question mark means Optional, as there might not be a value here
    @State private var showDeleteAlert = false //whether to show the delete confirmation alert,
    @State private var selectedRecord: SurveyRecord? = nil //the record whose details the user wants to view by tapping on it, question mark means Optional, as there might not be a value here
    @State private var showRecordDetail = false //controls whether to present the RecordDetailView

    
    //CLASS MAIN VIEW BODY
    var body: some View { //main computed UI body
        AppShell { //container for AbstractBackgroundView to be used behind everything below with the same specified parameters instead of initialising it directly and passing them every single time in each class like this
            
            List { //Scrollable view forming the main PastRecordView interface
                
                //TOP PART OF VIEW
                VStack(alignment: .leading, spacing: 12) { //VStack vertically aligns children elements defined below, spacing between everything that follows:
                    Text("Past Records") //Title, modifiers:
                        .font(.system(size: 40, weight: .bold))
                        .multilineTextAlignment(.leading)
                    Text("Review previous check-ins to spot patterns and track your wellbeing over time.") //Descriptive text, modifiers:
                        .font(.title3)
                        .foregroundStyle(.primary) //.primary here adapts between dark and light mode
                    Divider() //line to divide
                } //modifiers ONLY applying to divider and above:
                .listRowBackground(Color.clear)
                //.listRowSeparator(.hidden)

                //...still in List (scrollable view overall) but beyond the top section...
                
                //IF TO CONTROL EMPTY OR POPULATED LIST OF PAST RECORDS
                if store.records.isEmpty { //if nothing to show, show this:
                    Section { //Section is a container within List with logical grouping
                        VStack(spacing: 12) {
                            Text("No past records yet")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Text("Complete a Check-In to see it appear here.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } //modifiers for section:
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                        .padding(.horizontal)
                        .background( //below gives us the glassy blurred rectangle beneath no past records message
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay( //faint white outline around it
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }  //end of section
                } else { //IF ELSE clause starts here, for when there IS PastRecords in scope
                    
                    ForEach(store.records) { record in //loop through each SurveyRecord (store defined above, as a @StateObject, then reaches in to its .records property..
                        
                        Button { //create a tappable button to open detail, with properties:
                            selectedRecord = record //set selectedRecord to Record
                            showRecordDetail = true //force UI to render DetailView
                            
                        } label: { //part of Button definition
                            
                            HStack(alignment: .center, spacing: 12) { //HStack stacks everything side by side following the last in top to bototm order as defined below, spaced by 12
                                
                                //..still within the HStack..
                                VStack(alignment: .leading, spacing: 8) { //vertically stacks items within, spaced by 8
                                    
                                    Text(record.date, style: .date) //Date of Past Record
                                        .font(.headline)
                                    
                                    Text(record.date, style: .time) //Time of Past Record
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    
                                    //..still within the VStack, which is within the HStack inside a given button..
                                    
                                    HStack(spacing: 8) { //HStack for elements within to go side by side, top to bottom order, spaced by 8. This is the three colours of needs attention / okay / doing well
                                        
                                        //-Needs Attention Pill /Red
                                        Text("\(record.summary.bad) Needs Attention")
                                            .font(.caption.weight(.semibold))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                Capsule()
                                                    .fill(Color.red.opacity(0.15))
                                                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            )
                                            .foregroundStyle(.red)
                                        
                                        //-Doing Okay Pill /Orange
                                        Text("\(record.summary.neutral) Okay")
                                            .font(.caption.weight(.semibold))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                Capsule()
                                                    .fill(Color.yellow.opacity(0.2))
                                                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            )
                                            .foregroundStyle(.orange)

                                        //-Doing Well Pill /Yellow
                                        Text("\(record.summary.good) Doing Well") //gives the number within a Text string, calling from the current specified 'records'.summary.good property which is a numeric count of topics that scored as such..
                                            .font(.caption.weight(.semibold))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                Capsule() //built in Capsule struct specified with colour, shadow, used as the background for the Text element, modifiers:
                                                    .fill(Color.green.opacity(0.2))
                                                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            )
                                            .foregroundStyle(.green) //background colour still for Text element
                                    } //end of HStack for the three red/orange/green capsules

                                    //..still within the VStack, which is within the HStack inside a given button.. End of capsules, now on to optional ReflectionNote

                                    //if only shows if there is a ReflectionNote, trimmed
                                    if  !record.reflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { //removes spaces and newlines at the beginning of the string of the reflection note, checks after trimming if there is any left with isEmpty, so blank notes or ones with only spaces don't show
                                        Text(record.reflection)
                                            .font(.body)
                                            .padding(.top, 4)
                                    } //end of if for ReflectionNote
                                    
                                } //end of the VStack in a given Button instance, which houses the date / time / pill shapes
                                                               
                                Spacer() //spacer in the center within a Button between text on left and icon on right
                                Image(systemName: "chevron.right") //icon image on right of each button, modifiers:
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.secondary)
                                
                            } //End of first HStack inside Button instance, but still inside button. Modifiers apply to it for all of its items above:

                            .padding() //padding inside a given button
                            
                            .background( //button background fill / shape, these essentially give each row a card like modern look with glass effect, including .overlay below...
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.ultraThinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                            
                        } // End of Button Label modifiers to style / define functions of Button:
                        .buttonStyle(.plain)
                        
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) { //Swipe to delete
                            Button(role: .destructive) { //.destructive means the swipe 'button' revealed deletes the record that the button has selected
                                recordToDelete = record //specific record being deleted held here when button pressed
                                showDeleteAlert = true //triggers warning, when this button is pressed
                            } label: {
                                Label("Delete", systemImage: "trash")
                            } //defines text and image for delete alert
                        } //end of swipe action
                        
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 16))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        
                    } //end of the For Each listing button items
                    
                } //end of the If Else between 'no past record' message and the actual generated list of past records
                
            } //end of scrollable List item, modifiers to List below:
            
            .listStyle(.plain)
            .scrollContentBackground(.hidden) //hides default background colour for scrolling area which would be white or grey
            .background( //background colour consistent with other parts of the app using its accent colour:
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
                .ignoresSafeArea() //fills entire screen including menu bar / home button line area
            ) //end of .background
            
            .navigationDestination(isPresented: $showRecordDetail) { //triggers a push navigation to show a past record when pressed
                
                Group {  //if a selected record is there, store it in 'r', to pass to PastRecordDetailView, otherwise empty view
                    if let r = selectedRecord {
                        PastRecordDetailView(record: r)
                    } else {
                        EmptyView() //only one of these is required but by providing an empty one no runtime error if navigation is triggered with no record selected
                    }
                } //end of Group
                
            } //end of navigationDestination being presented
            
            .alert("Delete this record?", isPresented: $showDeleteAlert) { //when the showDeleteAlert is triggered, present the alert dialog box with cancel or delete options, delete uses 'r' to delete record it hzs inside from the Group above. Buttons are inside the alert so they are part of it:
                
                Button("Cancel", role: .cancel) { recordToDelete = nil } //clears record to delete
                
                Button("Delete", role: .destructive) { //acts to destruct/delete the record in r, then after that, sets the variable back to nil.
                    if let r = recordToDelete { store.remove(r) }
                    recordToDelete = nil
                } //end of isPresented for alert
                
            } message: { //message in alert body
                Text("This action cannot be undone.")
            }
            
        } //end of AppShell container
        
    } //end of main View body
    
} //end of PastRecordView struct


#Preview {
    PastRecordsView()
}

