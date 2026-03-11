// SB - ProgressDotsView
// Just for the little progress dots at the bottom of the survey view.

import Foundation
import SwiftUI

struct ProgressDotsView: View { //declaring the main class struct, conforming to View
    let current: Int //variables passed when this is instantiated / used in other Views
    let total: Int
    let skippedIndices: Set<Int> //defaults to an empty set

    init(current: Int, total: Int, skippedIndices: Set<Int> = []) { //initialise variables
        self.current = current //setting the value per instance object to the values passed above
        self.total = total // .. and defining them to local variables used privately in this class
        self.skippedIndices = skippedIndices
    }

    
    var body: some View { //every main View class needs a body defined, this defines the UI for the view and what's shown on screen
        
        ZStack(alignment: .bottom) { //ZStack is front/on top/bottom /back stacked for everything that follows, anchored bottom
            
            //fading edges left to right overlay
            HStack { Spacer() }.frame(height: 0) // HStack, means everything within follows the last side to side, top to bottom defined order here, anchor for bottom alignment.

            //content inside with fade mask on left/right
            HStack(spacing: 5) { //HStack everything within is on the right of the last, spaced by 8 all around
                
                ForEach(0..<total, id: \.self) { index in //LOOP to define number of dots/markets on screen
                    
                    if index == current { //for the current question dot to be a wider rounded line
                        Capsule()
                            .fill(Color.appAccent)
                            .frame(width: 16, height: 8)
                        
                    } else if skippedIndices.contains(index) { //condition if it's not current but is marked as skipped
                        Text("✕") //just use a letter X in this HStack
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.secondary)
                            .frame(width: 10, height: 8) //square box frame
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        
                    } else { //otherwise if not current and not skipped, it's a regular old circle
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                        
                    } //end of IF statement
                    
                } //end of FOR loop
                
            } //end of HStack with the spacing between current/x/dots
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: Color.black.opacity(0.0), location: 0.0),
                        .init(color: Color.black, location: 0.08),
                        .init(color: Color.black, location: 0.92),
                        .init(color: Color.black.opacity(0.0), location: 1.0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ) //end of LinearGradient
                
            ) //end of .mask
            
        } //end of overall VStack
        
    } //end of body View
    
} //end of class struct

