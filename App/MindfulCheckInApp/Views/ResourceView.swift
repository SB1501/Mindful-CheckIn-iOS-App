// SB - ResourceView
// Controls the view once each subject topic is tapped into... generic advice shown via this view. Data varies per topic.

import Foundation
import SwiftUI

struct ResourceView: View { //main struct to define this class
    
    let topic: QuestionTopic //classwide constant of topic which holds the QuestionTopic when this resource view is called, it must be called with one of the question topics to show
    
    @State private var showingDisclaimer = false // @State variable which controls the disclaimer view based on a button press defined below
    
    var body: some View { //defines what is drawn on screen of the UI, mandatory for View protocol
        
        ZStack { //what follows it front to back as defined
            
            topic.backgroundColor.ignoresSafeArea() //allows background colour belonging to each topic area to show full screen
            
            ScrollView { //main container for scrollable content view on screen
                
                VStack(alignment: .leading, spacing: 24) { //Top section: icon, title, summary
                    
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Image(systemName: topic.symbolName) //icon
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundStyle(.white)
                        Text(topic.resourceTitle) //title
                            .font(.system(size: 40, weight: .bold))
                            .multilineTextAlignment(.leading)
                    }
                    Text(topic.resourceSummary) //summary
                        .font(.title3)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) { //WHAT AND WHY SECTION
                        HStack {
                            ZStack{ //icon and circle
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.white)
                                Image(systemName: "questionmark.circle")
                                    .foregroundStyle(.black)
                            }
                            Text("What & Why") //sub heading
                                .font(.title3).bold()
                                .foregroundStyle(.primary)
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 6) { //actual content on new lines, parsed
                            ForEach(topic.resourceWhatWhy.split(separator: "\n").map(String.init), id: \.self) { line in
                                if !line.trimmingCharacters(in: .whitespaces).isEmpty {
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
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
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(topic.color.opacity(0.25), lineWidth: 1)
                    )
                    
                    
                    VStack(alignment: .leading, spacing: 8) { //POSITIVES SECTION
                        HStack {
                            ZStack{
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.white)
                                Image(systemName: "bolt.fill")
                                    .foregroundStyle(.black)
                            }
                            Text("Positives of Minding It")
                                .font(.title3).bold()
                                .foregroundStyle(.primary)
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(topic.resourcePositives.split(separator: "\n").map(String.init), id: \.self) { line in
                                if !line.trimmingCharacters(in: .whitespaces).isEmpty {
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Circle()
                                            .frame(width: 12, height: 12)
                                            .foregroundStyle(.secondary)
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
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(topic.color.opacity(0.25), lineWidth: 1)
                    )
                    
                    VStack(alignment: .leading, spacing: 8) { //NEGATIVES SECTION
                        HStack {
                            ZStack{
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.white)
                                Image(systemName: "chart.line.downtrend.xyaxis")
                                    .foregroundStyle(.black)
                            }
                            Text("Risks of Neglecting It")
                                .font(.title3).bold()
                                .foregroundStyle(.primary)
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(topic.resourceRisks.split(separator: "\n").map(String.init), id: \.self) { line in
                                if !line.trimmingCharacters(in: .whitespaces).isEmpty {
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Circle()
                                            .frame(width: 12, height: 12)
                                            .foregroundStyle(.secondary)
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
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(topic.color.opacity(0.25), lineWidth: 1)
                    )
                    
                    
                    VStack(alignment: .leading, spacing: 8) { //MANAGING SECTION
                        HStack {
                            ZStack{
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.white)
                                Image(systemName: "info")
                                    .foregroundStyle(.black)
                            }
                            Text("Tips for Managing")
                                .font(.title3).bold()
                                .foregroundStyle(.primary)
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(topic.resourceTips.split(separator: "\n").map(String.init), id: \.self) { line in
                                if !line.trimmingCharacters(in: .whitespaces).isEmpty {
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Circle()
                                            .frame(width: 12, height: 12)
                                            .foregroundStyle(.secondary)
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
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(topic.color.opacity(0.25), lineWidth: 1)
                    )
                    
                    Spacer()
                    
                    Button { //DISCLAIMER BUTTON
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
                
            } //end of ScrollView
            
            //.background(.thinMaterial)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                EmptyView()
            }
        }
    } //end of main body View
    
} //end of struct for this class ResourceView
 
#Preview {
    ResourceView(topic: .sleep)
}
