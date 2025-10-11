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
    
    var skippedTopics: [QuestionTopic] {
        let skippedIDs = Set(session.responses.filter { $0.wasSkipped }.map { $0.questionID })
        return questions.filter { skippedIDs.contains($0.id) }.map { $0.topic }
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
                        Text("🔴 Things to be Mindful of")
                            .font(.title3)
                            .fontWeight(.semibold)

                        ForEach(Array(flaggedTopics.enumerated()), id: \.offset) { _, topic in
                            NavigationLink(destination: ResourceView(topic: topic)) {
                                HStack(alignment: .center, spacing: 12) {
                                    Text("🔴")
                                        .font(.title3)
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
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                                )
                            }
                            .buttonStyle(.plain)
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

                        ForEach(Array(neutralTopics.enumerated()), id: \.offset) { _, topic in
                            NavigationLink(destination: ResourceView(topic: topic)) {
                                HStack(alignment: .center, spacing: 12) {
                                    Text("🟡")
                                        .font(.title3)
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
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }

                // Skipped Questions
                if !skippedTopics.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Questions you skipped")
                            .font(.title3)
                            .fontWeight(.semibold)
                        ForEach(Array(skippedTopics.enumerated()), id: \.offset) { _, topic in
                            Text("• \(topic.displayName)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
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

                        ForEach(Array(positiveTopics.enumerated()), id: \.offset) { _, topic in
                            NavigationLink(destination: ResourceView(topic: topic)) {
                                HStack(alignment: .center, spacing: 12) {
                                    Text("🟢")
                                        .font(.title3)
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
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                                )
                            }
                            .buttonStyle(.plain)
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

