// SB - ResourceHomeView
// Controls the view with all the question topics / subjects for reading / learning outside of the summary view.

import Foundation
import SwiftUI

struct ResourceHomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title and Intro
                    Text("Resources")
                        .font(.largeTitle)
                        .bold()

                    Text("Explore topics that support your wellbeing. Tap any to learn more about what it means, why it matters, and how to manage it.")
                        .font(.body)

                    Divider()

                    // Topic Buttons
                    ForEach(QuestionTopic.allCases, id: \.self) { topic in
                        NavigationLink(destination: ResourceView(topic: topic)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(topic.resourceTitle)
                                        .font(.title2)
                                        .bold()
                                    Text(topic.resourceSummary)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }

                    Divider()

                    // Disclaimer Link
                    NavigationLink("View Disclaimer", destination: DisclaimerView())
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding()
            }
            .navigationTitle("Resources")
        }
    }
}
