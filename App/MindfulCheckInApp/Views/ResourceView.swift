// SB - ResourceView
// Controls the view once each subject topic is tapped into... generic advice shown via this view. Data varies per topic.

import Foundation
import SwiftUI

struct ResourceView: View {
    let topic: QuestionTopic

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(topic.resourceTitle)
                    .font(.largeTitle)
                    .bold()

                Text(topic.resourceSummary)
                    .font(.body)

                Divider()

                Group {
                    Text("What & Why")
                        .font(.headline)
                    Text(topic.resourceWhatWhy)

                    Text("Positives of Minding It")
                        .font(.headline)
                    Text(topic.resourcePositives)

                    Text("Risks of Neglecting It")
                        .font(.headline)
                    Text(topic.resourceRisks)

                    Text("Tips for Managing")
                        .font(.headline)
                    Text(topic.resourceTips)
                }

                Divider()

                NavigationLink("View Disclaimer", destination: DisclaimerView())
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            .padding()
        }
        .navigationTitle(topic.resourceTitle)
    }
}
