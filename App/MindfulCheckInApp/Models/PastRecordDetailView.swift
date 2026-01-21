import Foundation
import SwiftUI

struct PastRecordDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = SurveyStore.shared

    let record: SurveyRecord
    @State private var reflection: String = ""
    @State private var showDeleteAlert = false
    @Environment(\.colorScheme) private var colorScheme

    private var jsonString: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? encoder.encode(record), let str = String(data: data, encoding: .utf8) {
            return str
        }
        return "{}"
    }

    var body: some View {
        AppShell {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Big date/time
                    VStack(spacing: 4) {
                        Text(record.date, style: .date)
                            .font(.system(size: 34, weight: .bold))
                        Text(record.date, style: .time)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)

                    // Read-only reflection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Reflection Note")
                            .font(.headline)
                        Text(reflection.isEmpty ? "No reflection added." : reflection)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.ultraThinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                    }

                    // Topic groups
                    if !record.positiveTopics.isEmpty {
                        TopicGroupView(title: "You're doing well on", color: .green, topics: record.positiveTopics)
                            .padding(.vertical, 8)
                    }
                    if !record.neutralTopics.isEmpty {
                        TopicGroupView(title: "You're doing okay on", color: .yellow, topics: record.neutralTopics)
                            .padding(.vertical, 8)
                    }
                    if !record.flaggedTopics.isEmpty {
                        TopicGroupView(title: "Things to be mindful of", color: .red, topics: record.flaggedTopics)
                            .padding(.vertical, 8)
                    }
                }
                .padding()
            }
            .background(
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
            )
        }
        .navigationTitle("Record Details")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }
        }
        .alert("Delete this record?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                store.remove(record)
                dismiss()
            }
        } message: {
            Text("This action cannot be undone.")
        }
        .onAppear {
            self.reflection = record.reflection
        }
    }
}

private struct TopicGroupView: View {
    let title: String
    let color: Color
    let topics: [QuestionTopic]

    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 170), spacing: 8)]
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3.weight(.semibold))
                .padding(.bottom, 4)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                ForEach(topics, id: \.self) { topic in
                    HStack(spacing: 6) {
                        Circle().fill(color.opacity(0.8)).frame(width: 8, height: 8)
                        Text(topic.displayName)
                            .font(.subheadline)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .frame(width: 170, alignment: .leading)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(color.opacity(0.15)))
                    .overlay(Capsule().stroke(color.opacity(0.25), lineWidth: 1))
                }
            }
        }
    }
}

