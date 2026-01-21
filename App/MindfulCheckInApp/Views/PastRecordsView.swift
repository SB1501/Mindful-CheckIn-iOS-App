// SB - PastRecordsView
// Allows users to look at previous Check-in Surveys to identify any common patterns.

import Foundation
import SwiftUI

struct PastRecordsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var store = SurveyStore.shared
    @State private var recordToDelete: SurveyRecord? = nil
    @State private var showDeleteAlert = false
    @State private var selectedRecord: SurveyRecord? = nil
    @State private var showRecordDetail = false

    var body: some View {
        AppShell {
            List {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Past Records")
                        .font(.system(size: 40, weight: .bold))
                        .multilineTextAlignment(.leading)
                    Text("Review previous check-ins to spot patterns and track your wellbeing over time.")
                        .font(.title3)
                        .foregroundStyle(.primary)
                    Divider()
                }
                .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

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
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                } else {
                    ForEach(store.records) { record in
                        Button {
                            selectedRecord = record
                            showRecordDetail = true
                        } label: {
                            HStack(alignment: .center, spacing: 12) {
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
                                            .background(
                                                Capsule()
                                                    .fill(Color.red.opacity(0.15))
                                                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            )
                                            .foregroundStyle(.red)

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

                                        Text("\(record.summary.good) Doing Well")
                                            .font(.caption.weight(.semibold))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                Capsule()
                                                    .fill(Color.green.opacity(0.2))
                                                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            )
                                            .foregroundStyle(.green)
                                    }

                                    if !record.reflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                        Text(record.reflection)
                                            .font(.body)
                                            .padding(.top, 4)
                                    }
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.ultraThinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                recordToDelete = record
                                showDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 16))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
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
            .navigationTitle("Past Records")
            .navigationDestination(isPresented: $showRecordDetail) {
                Group {
                    if let r = selectedRecord {
                        PastRecordDetailView(record: r)
                    } else {
                        EmptyView()
                    }
                }
            }
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
}

