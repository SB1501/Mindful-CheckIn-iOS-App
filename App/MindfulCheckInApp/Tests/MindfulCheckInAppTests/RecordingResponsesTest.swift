//
//  RecordingResponsesTest.swift
//  MindfulCheckInAppTests
//
//  Created by Shane Bunting on 28/01/2026.
//

import Testing
@testable import MindfulCheckInApp

@Suite("Recording Responses")
struct RecordingResponsesTests {
    @Test
    func recordReplacesPreviousAndUpdatesCategories() {
        let manager = SurveyManager()
        let q = makeScaleQuestion(topic: .hydration)

        manager.questions = [q]

        manager.recordResponse(for: q, answer: .scale(5)) // positive
        #expect(manager.session.positiveTopics.contains(q.topic))
        #expect(!manager.session.flaggedTopics.contains(q.topic))

        manager.recordResponse(for: q, answer: .scale(1)) // now negative
        #expect(manager.session.flaggedTopics.contains(q.topic))
        #expect(!manager.session.positiveTopics.contains(q.topic))

        // Only one response for the question should exist
        #expect(manager.responses.filter { $0.questionID == q.id }.count == 1)
    }
}
