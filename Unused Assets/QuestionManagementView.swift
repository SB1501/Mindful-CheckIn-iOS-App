// SB MINDFUL CHECK-IN - For a future release, currently not utilised anywhere in the app.

import SwiftUI

struct QuestionsSettingsView: View { //class definition / struct conforming to View protocol
    
    private let questions = ["Body", "Space", "Rhythm", "Mood", "Notes"] //local private array of the categories of questions used below
    
    
    var body: some View { //every view requires a body View which shows the actual drawn on screen elements
        
        List { //List UI element from SwiftUI

            ForEach(questions, id: \.self) { question in
                Toggle(isOn: binding(for: question)) { //binded to the Bool stored in UserDefaults (local app memory for simple settings etc), can read and write to it for 'question' which itself is based on the array question's' above
                    Text(question) //For Loop for each item inthe array, with the toggle property enabled
                }
            }
            
            Section(footer: Text("Turning off a question hides it from future check-ins but it may still appear in past records.")) {
                EmptyView() //descriptive text under the settings list. EmptyView is a placeholder for the section to show the footer
            }
        } //end of List, modifiers for List:
        .navigationTitle("Question Settings")
        .listStyle(InsetGroupedListStyle())
    }
    
    //FUNCTIONS
    
    //this creates a Binding<Bool> for a given question, attached to what is stored in User Defaults. It allows each question be set an on/off value
    private func binding(for question: String) -> Binding<Bool> {
        let key = "question_enabled_\(question)" //builds a unique key per question
        return Binding( //a two way binding with explicit get/set closures
            get: {
                UserDefaults.standard.object(forKey: key) as? Bool ?? true //reads stored value in UserDefaults, but it might not exist or be set, if so, defaults to true
            },
            set: { //persists new boolean value as set by the user (in $0) to the User Defaults under its computed key above
                UserDefaults.standard.set($0, forKey: key)
            }
        ) //end of Binding return
    } //end of method binding
    
} //end of main class struct QuestionSettingsView View

//PREVIEW

struct QuestionsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QuestionsSettingsView()
        }
    }
}
