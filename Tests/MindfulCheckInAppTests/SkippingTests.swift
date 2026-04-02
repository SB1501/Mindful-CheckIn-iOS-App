//
//  SkippingTests.swift
//  MindfulCheckInAppTests
//
//  Created by Shane Bunting on 28/01/2026.
//

import Testing
@testable import MindfulCheckInApp

@Suite("Skipping Questions")
struct SkippingTests {
    @Test
    func skipAddsSkippedResponseAndRemovesFromCategories() {
        let manager = SurveyManager()
        let q = makeScaleQuestion(topic: .focus)

        manager.questions = [q]
        manager.recordResponse(for: q, answer: .scale(5)) // positive
        #expect(manager.session.positiveTopics.contains(q.topic))

        manager.currentIndex = 0
        manager.skipQuestion()

        // Skipped response exists
        let skipped = manager.responses.first { $0.questionID == q.id }
        #expect(skipped?.wasSkipped == true)

        // Topic removed from categories after skip
        #expect(!manager.session.positiveTopics.contains(q.topic))
        #expect(!manager.session.flaggedTopics.contains(q.topic))
        #expect(!manager.session.neutralTopics.contains(q.topic))
    }
}
