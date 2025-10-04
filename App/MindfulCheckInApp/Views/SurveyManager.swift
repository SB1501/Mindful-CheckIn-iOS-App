// SB - SurveyManager
// Coordinates the data model, question loading, skipping and counting for end summary.

import Foundation
import SwiftUI
import Combine

class SurveyManager: ObservableObject {
    @Published var questions: [SurveyQuestion] = []
    @Published var responses: [SurveyResponse] = []
    @Published var currentIndex: Int = 0

    var reflectionNote: String = ""
    var session = SurveySession(id: UUID(), date: Date(), responses: [])

    func loadQuestions() {
        guard let url = Bundle.main.url(forResource: "sampleQuestions", withExtension: "json") else {
            print("sampleQuestions.json not found in bundle.")
            self.questions = []
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([SurveyQuestion].self, from: data)
            self.questions = decoded
        } catch {
            print("Failed to decode sampleQuestions.json: \(error)")
            self.questions = []
        }

        // Reset state for a fresh run
        self.responses = []
        self.currentIndex = 0
        self.session = SurveySession(id: UUID(), date: Date(), responses: [])
    }

    func recordResponse(for question: SurveyQuestion, answer: AnswerValue) {
        let response = SurveyResponse(
            id: UUID(),
            questionID: question.id,
            answer: answer,
            timestamp: Date(),
            wasSkipped: false
        )

        responses.append(response)

        // Evaluate and store topic (deduplicate per topic)
        let cat = category(for: answer, question: question)
        switch cat {
        case .negative:
            if !session.flaggedTopics.contains(question.topic) {
                session.flaggedTopics.append(question.topic)
            }
        case .neutral:
            if !session.neutralTopics.contains(question.topic) {
                session.neutralTopics.append(question.topic)
            }
        case .positive:
            if !session.positiveTopics.contains(question.topic) {
                session.positiveTopics.append(question.topic)
            }
        }
    }

    func skipQuestion() {
        let skipped = SurveyResponse(
            id: UUID(),
            questionID: questions[currentIndex].id,
            answer: .scale(0),
            timestamp: Date(),
            wasSkipped: true
        )
        responses.append(skipped)
        advance()
    }

    func goBack() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }

    func advance() {
        if currentIndex < questions.count {
            currentIndex += 1
        }
        print("Current index: \(currentIndex) / \(questions.count)")
    }
    

    func generateSession() -> SurveySession {
        session.responses = responses
        session.reflectionNote = reflectionNote
        return session
    }
    
    func category(for answer: AnswerValue, question: SurveyQuestion) -> AnswerCategory {
        // Prefer per-question scoring rules if present
        if let rule = question.scoring {
            switch answer {
            case .scale(let value):
                let higherIsBetter = rule.higherIsBetter ?? true
                if let max = rule.flaggedMaxScale {
                    if higherIsBetter, value <= max { return .negative }
                    if !higherIsBetter, value >= max { return .negative }
                }
                if let min = rule.positiveMinScale {
                    if higherIsBetter, value >= min { return .positive }
                    if !higherIsBetter, value <= min { return .positive }
                }
                // If thresholds are provided, anything in-between is neutral
                if rule.flaggedMaxScale != nil || rule.positiveMinScale != nil {
                    return .neutral
                }
            case .choice(let value):
                if let negatives = rule.flaggedChoices, negatives.contains(value) { return .negative }
                if let positives = rule.positiveChoices, positives.contains(value) { return .positive }
                if let neutrals = rule.neutralChoices, neutrals.contains(value) { return .neutral }
            }
        }

        // Default behavior
        switch answer {
        case .scale(let value):
            if value >= 4 { return .positive }
            if value == 3 { return .neutral }
            return .negative
        case .choice(let value):
            if value == "Plenty" || value == "High" { return .positive }
            if value == "Some" || value == "Medium" { return .neutral }
            return .negative // e.g., "None", "Low"
        }
    }
    
    func isFlagged(_ answer: AnswerValue, for question: SurveyQuestion) -> Bool {
        if let rule = question.scoring {
            switch answer {
            case .scale(let value):
                if let max = rule.flaggedMaxScale { return value <= max }
            case .choice(let value):
                if let flagged = rule.flaggedChoices { return flagged.contains(value) }
            }
        }
        // Default behavior
        switch answer {
        case .scale(let value): return value <= 2
        case .choice(let value): return value == "None" || value == "Low"
        }
    }

    func isPositive(_ answer: AnswerValue, for question: SurveyQuestion) -> Bool {
        if let rule = question.scoring {
            switch answer {
            case .scale(let value):
                if let min = rule.positiveMinScale { return value >= min }
            case .choice(let value):
                if let positive = rule.positiveChoices { return positive.contains(value) }
            }
        }
        // Default behavior
        switch answer {
        case .scale(let value): return value >= 4
        case .choice(let value): return value == "Plenty" || value == "High"
        }
    }

    func isNeutral(_ answer: AnswerValue, for question: SurveyQuestion) -> Bool {
        if let rule = question.scoring {
            switch answer {
            case .scale(let value):
                if let min = rule.positiveMinScale, let max = rule.flaggedMaxScale {
                    return value > max && value < min
                }
            case .choice(let value):
                if let neutral = rule.neutralChoices { return neutral.contains(value) }
            }
        }
        // Default behavior
        switch answer {
        case .scale(let value): return value == 3
        case .choice(let value): return value == "Some" || value == "Medium"
        }
    }
    
}
