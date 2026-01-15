// SB - ResourceHomeView
// Controls the view with all the question topics / subjects for reading / learning outside of the summary view.

import Foundation
import SwiftUI


struct ResourceHomeView: View {
    
    @State private var showingDisclaimer = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Resources")
                        .font(.system(size: 40, weight: .bold))
                        .multilineTextAlignment(.leading)
                    // Intro
                    Text("Explore topics that support your wellbeing. Tap any to learn more about what it means, why it matters, and how to manage it.")
                        .font(.title3)
                        .foregroundStyle(.primary)
                    
                    Divider()
                    
                    // Topic Buttons
                    ForEach(QuestionTopic.allCases, id: \.self) { topic in
                        NavigationLink(destination: ResourceView(topic: topic)) {
                            HStack(spacing: 12) {
                                // Placeholder icon/emoji
                                ZStack {
                                    Circle()
                                        .fill(topic.color.opacity(0.25))
                                        .frame(width: 44, height: 44)
                                    Text("📘")
                                        .font(.title3)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(topic.resourceTitle)
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(topic.backgroundColor)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(topic.color.opacity(0.2), lineWidth: 1)
                            )
                        }
                    }
                    
                    Divider()
                    
                    // Disclaimer Link
                    Button {
                        showingDisclaimer = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.white)
                            Text("View Disclaimer")
                                .bold()
                                .foregroundStyle(.white)
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
                    
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            }
            .padding()
        }
    }
    
}
