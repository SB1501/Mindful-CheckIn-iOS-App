//
//  MindfulCheckInTests.swift
//  MindfulCheckInTests
//
//  Created by Shane Bunting on 10/06/2026.
//

import Foundation
import Testing
@testable import MindfulCheckInApp

@Suite("Wiring")
struct WiringTests {

    @Test("Target compiles and we can reference app types")
    func basicWiring() {
        // Touch a type from the app to prove visibility.
        // Using a lightweight reference avoids side effects.
        _ = SurveyRecord(
            date: .now,
            summary: SurveySummary(good: 0, neutral: 0, bad: 0),
            reflection: "",
            positiveTopics: [],
            neutralTopics: [],
            flaggedTopics: []
        )

        // A trivial expectation just to see green.
        #expect(2 + 2 == 4)
    }
}
