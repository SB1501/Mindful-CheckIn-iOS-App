// SB - ResourceHomeView
// Controls the view with all the question topics / subjects for reading / learning outside of the summary view.

import Foundation
import SwiftUI


struct ResourceHomeView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingDisclaimer = false
    
    var body: some View {
        AppShell {
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
                                    // Placeholder icon/emoji replaced with SF Symbol
                                    ZStack {
                                        Circle()
                                            .fill(topic.color.opacity(0.25))
                                            .frame(width: 44, height: 44)
                                        Image(systemName: topic.symbolName)
                                            .font(.title3)
                                            .foregroundStyle(.white)
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
    }
    
}
