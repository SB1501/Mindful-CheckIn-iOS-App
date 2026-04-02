//
//  CustomScoringTests.swift
//  MindfulCheckInAppTests
//
//  Created by Shane Bunting on 28/01/2026.
//

import Testing
@testable import MindfulCheckInApp

@Suite("Custom Scoring Rules")
struct CustomScoringTests {
    @Test("Higher is worse: 5 should be negative, 1 positive")
    func higherIsWorse() async throws {
        let rule = ScoringRule(
            positiveChoices: nil,
            neutralChoices: nil,
            flaggedChoices: nil,
            flaggedMaxScale: 5,    // 5 is flagged (negative)
            positiveMinScale: 1,   // anything <= 2 positive when higherIsBetter == false
            higherIsBetter: false
        )
        let manager = await SurveyManager()
        let q = makeScaleQuestion(topic: .sugar, scoring: rule)

        #expect(manager.category(for: .scale(5), question: q) == .negative)
        #expect(manager.category(for: .scale(1), question: q) == .positive)
    }
}
