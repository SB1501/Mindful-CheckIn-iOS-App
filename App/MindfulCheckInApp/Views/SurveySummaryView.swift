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
            VStack(spacing: 24) {
                // Consistent large title
                Text("Check-In Summary")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Mindful (Flagged) grouped in one card
                if !flaggedTopics.isEmpty {
                    SummaryGroupCard(title: "🔴 Things to be Mindful of") {
                        VStack(spacing: 12) {
                            ForEach(Array(flaggedTopics.enumerated()), id: \.offset) { _, topic in
                                NavigationLink(destination: ResourceView(topic: topic)) {
                                    HStack(alignment: .center, spacing: 12) {
                                        Text("🔴").font(.title3)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(topic.displayName).font(.headline).fontWeight(.semibold)
                                            Text(topic.flaggedSummary).font(.subheadline).foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right").foregroundStyle(.secondary)
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
                    }
                }

                // Okay (Neutral) grouped in one card
                if !neutralTopics.isEmpty {
                    SummaryGroupCard(title: "🟡 Things you're doing okay on") {
                        VStack(spacing: 12) {
                            ForEach(Array(neutralTopics.enumerated()), id: \.offset) { _, topic in
                                NavigationLink(destination: ResourceView(topic: topic)) {
                                    HStack(alignment: .center, spacing: 12) {
                                        Text("🟡").font(.title3)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(topic.displayName).font(.headline).fontWeight(.semibold)
                                            Text(topic.neutralSummary).font(.subheadline).foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right").foregroundStyle(.secondary)
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
                    }
                }

                // Well (Positive) after Okay
                if !positiveTopics.isEmpty {
                    SummaryGroupCard(title: "🟢 Things you're doing well on") {
                        VStack(spacing: 12) {
                            ForEach(Array(positiveTopics.enumerated()), id: \.offset) { _, topic in
                                NavigationLink(destination: ResourceView(topic: topic)) {
                                    HStack(alignment: .center, spacing: 12) {
                                        Text("🟢").font(.title3)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(topic.displayName).font(.headline).fontWeight(.semibold)
                                            Text(topic.positiveSummary).font(.subheadline).foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right").foregroundStyle(.secondary)
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
                    }
                }

                // Reflection Note in its own card
                SummaryGroupCard(title: "📝 Reflection Note") {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("Write a quick note...", text: $reflectionNote, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3, reservesSpace: true)
                            .toolbar { // done button above keyboard
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
                                }
                            }
                    }
                }

                // Skipped Questions (minimal)
                if !skippedTopics.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Questions you skipped").font(.headline)
                        ForEach(Array(skippedTopics.enumerated()), id: \.offset) { _, topic in
                            Text("• \(topic.displayName)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // Big Finish button
                Button(action: {
                    // Build and persist the record once
                    let session = session
                    let summary = SurveySummary(
                        good: positiveTopics.count,
                        neutral: neutralTopics.count,
                        bad: flaggedTopics.count
                    )
                    let record = SurveyRecord(
                        date: session.date,
                        summary: summary,
                        reflection: reflectionNote,
                        positiveTopics: positiveTopics,
                        neutralTopics: neutralTopics,
                        flaggedTopics: flaggedTopics
                    )
                    SurveyStore.shared.add(record)
                    isSaved = true
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Finish & Save")
                    }
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.accentColor)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 6)
                }
                .buttonStyle(.plain)
                .disabled(isSaved)
                .opacity(isSaved ? 0.6 : 1.0)

                // Back to Main Menu after saving
                if isSaved {
                    NavigationLink("Back to Main Menu", destination: MainMenuView())
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }
}

private struct SummaryGroupCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3).fontWeight(.semibold)
            content
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}
