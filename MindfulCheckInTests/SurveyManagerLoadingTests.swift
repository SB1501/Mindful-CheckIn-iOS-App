import Testing
@testable import MindfulCheckInApp
import Foundation

@Suite("SurveyManager loading")
struct SurveyManagerLoadingTests {

    @Test("Load questions from injected data and reset state")
    func loadFromDataProvider() throws {
        // Minimal inline JSON for two questions
        let json = """
        [
          {
            "id": "00000000-0000-0000-0000-000000000010",
            "title": "Sleep amount",
            "topic": "sleep",
            "inputType": "slider",
            "isEnabled": true
          },
          {
            "id": "00000000-0000-0000-0000-000000000011",
            "title": "Hydration",
            "topic": "hydration",
            "inputType": "buttonGroup",
            "isEnabled": true,
            "options": ["None", "Some", "Plenty"]
          }
        ]
        """
        let data = Data(json.utf8)

        let sut = SurveyManager()
        // Pre-populate state to verify it resets after loading
        sut.responses = [
            SurveyResponse(id: .init(), questionID: .init(), answer: .scale(5), timestamp: Date(), wasSkipped: false)
        ]
        sut.currentIndex = 5

        try sut.loadQuestions(dataProvider: { data })

        #expect(sut.questions.count == 2)
        #expect(sut.questions[0].topic == .sleep)
        #expect(sut.questions[1].topic == .hydration)
        // state reset
        #expect(sut.responses.isEmpty)
        #expect(sut.currentIndex == 0)
    }

    @Test("Bad JSON throws and does not change existing state")
    func badJSON() {
        let bad = Data("{".utf8) // invalid JSON
        let sut = SurveyManager()
        sut.responses = [SurveyResponse(id: .init(), questionID: .init(), answer: .scale(1), timestamp: Date(), wasSkipped: true)]
        sut.currentIndex = 3

        do {
            try sut.loadQuestions(dataProvider: { bad })
            Issue.record("Expected throw for bad JSON, but succeeded")
        } catch {
            // For the throwing overload, we expect no state change on failure.
            #expect(sut.currentIndex == 3)
            #expect(!sut.responses.isEmpty)
        }
    }
}
