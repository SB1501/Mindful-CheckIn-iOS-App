// SB - ResourceView
// Controls the view once each subject topic is tapped into... generic advice shown via this view. Data varies per topic.

import Foundation
import SwiftUI

struct ResourceView: View {
    let topic: QuestionTopic
    @State private var showingDisclaimer = false

    var body: some View {
        ZStack {
            topic.backgroundColor.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text("📘")
                            .font(.system(size: 40))
                        Text(topic.resourceTitle)
                            .font(.system(size: 40, weight: .bold))
                            .multilineTextAlignment(.leading)
                    }

                    Text(topic.resourceSummary)
                        .font(.title3)
                        .foregroundStyle(.primary)

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("What & Why")
                            .font(.title3).bold()
                            .foregroundStyle(.primary)
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(topic.resourceWhatWhy.split(separator: "\n").map(String.init), id: \.self) { line in
                                if !line.trimmingCharacters(in: .whitespaces).isEmpty {
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Text("•")
                                        Text(line)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.thinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(topic.color.opacity(0.25), lineWidth: 1)
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Positives of Minding It")
                            .font(.title3).bold()
                            .foregroundStyle(.primary)
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(topic.resourcePositives.split(separator: "\n").map(String.init), id: \.self) { line in
                                if !line.trimmingCharacters(in: .whitespaces).isEmpty {
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Text("•")
                                        Text(line)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.thinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(topic.color.opacity(0.25), lineWidth: 1)
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Risks of Neglecting It")
                            .font(.title3).bold()
                            .foregroundStyle(.primary)
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(topic.resourceRisks.split(separator: "\n").map(String.init), id: \.self) { line in
                                if !line.trimmingCharacters(in: .whitespaces).isEmpty {
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Text("•")
                                        Text(line)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.thinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(topic.color.opacity(0.25), lineWidth: 1)
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tips for Managing")
                            .font(.title3).bold()
                            .foregroundStyle(.primary)
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(topic.resourceTips.split(separator: "\n").map(String.init), id: \.self) { line in
                                if !line.trimmingCharacters(in: .whitespaces).isEmpty {
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Text("•")
                                        Text(line)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.thinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(topic.color.opacity(0.25), lineWidth: 1)
                    )

                    Divider()

                    Button {
                        showingDisclaimer = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.white)
                            Text("View Disclaimer").bold().foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .padding(.horizontal)
                        

                    }
                    .buttonStyle(.glassProminent)
                    .tint(.red)
                    .sheet(isPresented: $showingDisclaimer) {
                        DisclaimerView()
                    }
                }
                .padding()
            }
            .background(.thinMaterial)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                EmptyView()
            }
        }
    }
}

