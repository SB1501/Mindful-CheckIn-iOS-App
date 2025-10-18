import Foundation
import SwiftUI

struct PastRecordDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = SurveyStore.shared

    let record: SurveyRecord
    @State private var reflection: String = ""
    @State private var showDeleteAlert = false

    private var jsonString: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? encoder.encode(record), let str = String(data: data, encoding: .utf8) {
            return str
        }
        return "{}"
    }

    var body: some View {
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

                // Editable reflection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reflection Note")
                        .font(.headline)
                    TextEditor(text: $reflection)
                        .frame(minHeight: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color(.secondarySystemBackground))
                        )
                }

                // Topic groups
                if !record.positiveTopics.isEmpty {
                    TopicGroupView(title: "You're doing well on", color: .green, topics: record.positiveTopics)
                }
                if !record.neutralTopics.isEmpty {
                    TopicGroupView(title: "You're doing okay on", color: .yellow, topics: record.neutralTopics)
                }
                if !record.flaggedTopics.isEmpty {
                    TopicGroupView(title: "Things to be mindful of", color: .red, topics: record.flaggedTopics)
                }

                // Raw JSON (optional)
                DisclosureGroup("Raw JSON (for reference)") {
                    ScrollView(.horizontal) {
                        Text(jsonString)
                            .font(.system(.footnote, design: .monospaced))
                            .textSelection(.enabled)
                    }
                }
                .tint(.secondary)
            }
            .padding()
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
        .onChange(of: reflection) { _, newValue in
            // Persist reflection edits by updating the record in the store without directly mutating `records`
            var updated = record
            updated.reflection = newValue
            // Use the store's public API to replace the record
            store.remove(record)
            store.add(updated)
        }
    }
}

private struct TopicGroupView: View {
    let title: String
    let color: Color
    let topics: [QuestionTopic]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            FlowLayout(alignment: .leading, spacing: 8) {
                ForEach(topics, id: \.self) { topic in
                    HStack(spacing: 6) {
                        Circle().fill(color.opacity(0.8)).frame(width: 8, height: 8)
                        Text(topic.displayName)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(color.opacity(0.15))
                    )
                    .overlay(
                        Capsule().stroke(color.opacity(0.25), lineWidth: 1)
                    )
                }
            }
        }
    }
}

// A minimal flow layout for wrapping chips
private struct FlowLayout<Content: View>: View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content

    init(alignment: HorizontalAlignment = .leading, spacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: alignment, vertical: .top)) {
                content()
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > geometry.size.width) {
                            width = 0
                            height -= d.height + spacing
                        }
                        let result = width
                        if topicIsLast(d) { width = 0 } else { width -= d.width + spacing }
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        return result
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: nil)
    }

    private func topicIsLast(_ d: ViewDimensions) -> Bool { false }
}
