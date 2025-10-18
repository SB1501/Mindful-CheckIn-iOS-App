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
                    Text(topic.resourceTitle)
                        .font(.largeTitle)
                        .bold()

                    Text(topic.resourceSummary)
                        .font(.body)

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("What & Why")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(topic.resourceWhatWhy)
                    }
                    .padding()
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
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(topic.resourcePositives)
                    }
                    .padding()
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
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(topic.resourceRisks)
                    }
                    .padding()
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
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(topic.resourceTips)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.thinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(topic.color.opacity(0.25), lineWidth: 1)
                    )

                    Divider()

                    Button("View Disclaimer") {
                        showingDisclaimer = true
                    }
                    .font(.footnote)
                    .foregroundColor(.red)
                    .sheet(isPresented: $showingDisclaimer) {
                        NavigationStack {
                            DisclaimerView()
                                .toolbar {
                                    ToolbarItem(placement: .topBarLeading) {
                                        Button("Done") { showingDisclaimer = false }
                                    }
                                }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(topic.resourceTitle)
    }
}
