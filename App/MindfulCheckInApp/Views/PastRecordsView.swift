// SB - PastRecordsView
// Allows users to look at previous Check-in Surveys to identify any common patterns.

import Foundation
import SwiftUI

struct PastRecordsView: View {
    @StateObject private var store = SurveyStore.shared
    @State private var recordToDelete: SurveyRecord? = nil
    @State private var showDeleteAlert = false

    var body: some View {
        List {
            if store.records.isEmpty {
                Section {
                    VStack(spacing: 12) {
                        Text("No past records yet")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text("Complete a check-in to see it appear here.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                }
            } else {
                ForEach(store.records) { record in
                    NavigationLink(destination: PastRecordDetailView(record: record)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(record.date, style: .date)
                                .font(.headline)
                            Text(record.date, style: .time)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            HStack(spacing: 8) {
                                Text("\(record.summary.bad) Needs Attention")
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(Color.red.opacity(0.15)))
                                    .foregroundStyle(.red)

                                Text("\(record.summary.neutral) Okay")
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(Color.yellow.opacity(0.2)))
                                    .foregroundStyle(.orange)

                                Text("\(record.summary.good) Doing Well")
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(Color.green.opacity(0.2)))
                                    .foregroundStyle(.green)
                            }

                            if !record.reflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text(record.reflection)
                                    .font(.body)
                                    .padding(.top, 4)
                            }
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            recordToDelete = record
                            showDeleteAlert = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle("Past Records")
        .alert("Delete this record?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { recordToDelete = nil }
            Button("Delete", role: .destructive) {
                if let r = recordToDelete { store.remove(r) }
                recordToDelete = nil
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

