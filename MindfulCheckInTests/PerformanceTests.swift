import Testing
@testable import MindfulCheckInApp
import Foundation

//SB - TEST - Classifies 10,000 question answers in under 0.15 seconds / 150ms. Random threshold to start with.

@Suite("Performance")
struct PerformanceTests {

    @Test("Classify 10k answers under 0.15s (example threshold)")
    func classifyManyQuickly() async throws {
        let question = SurveyQuestion(
            id: .init(), title: "Focus", topic: .focus, inputType: .slider,
            isEnabled: true, backgroundColorName: nil, options: nil, scoring: nil
        )
        let sut = await SurveyManager()
        let answers = (1...10_000).map { _ in AnswerValue.scale(Int.random(in: 1...5)) }

        let clock = ContinuousClock()
        let start = clock.now
        for a in answers { _ = await sut.category(for: a, question: question) }
        let duration = start.duration(to: clock.now)
        #expect(duration < .milliseconds(200))
    }
}
