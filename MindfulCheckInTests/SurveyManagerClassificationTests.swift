import Testing
@testable import MindfulCheckInApp
import Foundation

//SB - TEST - Verifies default slider classification, where no scoring rules, and where there is a per question scoring rule. 


@Suite("SurveyManager classification")
struct SurveyManagerClassificationTests {

    @Test("Default slider classification (no scoring rule)")
    func defaultSliderClassification() {
        let question = SurveyQuestion(
            id: .init(),
            title: "Energy today?",
            topic: .motivation,
            inputType: .slider,
            isEnabled: true,
            backgroundColorName: nil,
            options: nil,
            scoring: nil
        )
        let sut = SurveyManager()

        #expect(sut.category(for: .scale(5), question: question) == .positive)
        #expect(sut.category(for: .scale(3), question: question) == .neutral)
        #expect(sut.category(for: .scale(1), question: question) == .negative)
    }

    @Test("Choice classification with per-question scoring")
    func choiceClassificationWithRule() {
        let rule = ScoringRule(
            positiveChoices: ["Plenty", "High"],
            neutralChoices: ["Some", "Medium"],
            flaggedChoices: ["None", "Low"],
            flaggedMaxScale: nil,
            positiveMinScale: nil,
            higherIsBetter: nil
        )
        let question = SurveyQuestion(
            id: .init(),
            title: "Hydration",
            topic: .hydration,
            inputType: .buttonGroup,
            isEnabled: true,
            backgroundColorName: nil,
            options: ["None", "Low", "Some", "Plenty"],
            scoring: rule
        )
        let sut = SurveyManager()

        #expect(sut.category(for: .choice("Plenty"), question: question) == .positive)
        #expect(sut.category(for: .choice("Some"), question: question) == .neutral)
        #expect(sut.category(for: .choice("Low"), question: question) == .negative)
    }
}
