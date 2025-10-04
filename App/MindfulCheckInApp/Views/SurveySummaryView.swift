// SB - SurveySummaryView
// Controls the view of the end of survey for a summary of topics 'good' 'neutral' and 'bad' and reflection note input

import SwiftUI

struct SurveySummaryView: View {
    let session: SurveySession
    let questions: [SurveyQuestion]

    @State private var reflectionNote: String = ""
    @State private var isSaved = false

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

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Check-In Summary")
                    .font(.title)
                    .bold()

                // Flagged Topics
                if !flaggedTopics.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🔴 Things to focus on")
                            .font(.title3)
                            .fontWeight(.semibold)

                        ForEach(Array(flaggedTopics.enumerated()), id: \.offset) { index, topic in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(topic.displayName)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Text(topic.flaggedSummary)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                NavigationLink("Learn more", destination: ResourceView(topic: topic))
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                }

                // Neutral Topics
                if !neutralTopics.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🟡 Things you're doing okay on")
                            .font(.title3)
                            .fontWeight(.semibold)

                        ForEach(Array(neutralTopics.enumerated()), id: \.offset) { index, topic in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(topic.displayName)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Text(topic.neutralSummary)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                NavigationLink("Learn more", destination: ResourceView(topic: topic))
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                }

                // Reflection Note
                VStack(alignment: .leading, spacing: 10) {
                    Text("📝 Reflection Note")
                        .font(.headline)
                    TextField("Write a quick note...", text: $reflectionNote)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()

                // Positive Topics
                if !positiveTopics.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🟢 Things you're doing well on")
                            .font(.title3)
                            .fontWeight(.semibold)

                        ForEach(Array(positiveTopics.enumerated()), id: \.offset) { index, topic in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(topic.displayName)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Text(topic.positiveSummary)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                NavigationLink("Learn more", destination: ResourceView(topic: topic))
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                }

                // Save Button
                Button("Finish & Save") {
                    saveSession()
                    isSaved = true
                }
                .buttonStyle(.borderedProminent)

                // Navigation
                if isSaved {
                    NavigationLink("Back to Main Menu", destination: MainMenuView())
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }

    func saveSession() {
        print("Session saved with note: \(reflectionNote)")
        // TODO: Persist the session and reflection note to storage when a data layer is added.
    }
}

