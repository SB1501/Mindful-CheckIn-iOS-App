import Testing
import Foundation
@testable import MindfulCheckInApp

//SB - TEST - Decodes a very small JSON array into a SurveyQuestion and then checks some fields.

@Suite("Decoding")
struct DecodingTests {

    @Test
    func decodeSurveyQuestion() throws {
        let json = """
        [{
          "id": "00000000-0000-0000-0000-000000000001",
          "title": "How much sleep have you had?",
          "topic": "sleep",
          "inputType": "buttonGroup",
          "isEnabled": true,
          "options": ["None", "Low", "Some", "Plenty"]
        }]
        """
        let data = Data(json.utf8)
        let questions = try JSONDecoder().decode([SurveyQuestion].self, from: data)
        #expect(questions.count == 1)
        #expect(questions[0].topic == .sleep)
        #expect(questions[0].options?.contains("Plenty") == true)
    }
}
