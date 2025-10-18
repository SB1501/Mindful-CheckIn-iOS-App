import SwiftUI

struct QuestionsSettingsView: View {
    private let questions = ["Body", "Space", "Rhythm", "Mood", "Notes"]
    
    var body: some View {
        List {
            ForEach(questions, id: \.self) { question in
                Toggle(isOn: binding(for: question)) {
                    Text(question)
                }
            }
            
            Section(footer: Text("Turning off a question hides it from future check-ins but it may still appear in past records.")) {
                EmptyView()
            }
        }
        .navigationTitle("Question Settings")
        .listStyle(InsetGroupedListStyle())
    }
    
    private func binding(for question: String) -> Binding<Bool> {
        let key = "question_enabled_\(question)"
        return Binding(
            get: {
                UserDefaults.standard.object(forKey: key) as? Bool ?? true
            },
            set: {
                UserDefaults.standard.set($0, forKey: key)
            }
        )
    }
}

struct QuestionsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QuestionsSettingsView()
        }
    }
}
