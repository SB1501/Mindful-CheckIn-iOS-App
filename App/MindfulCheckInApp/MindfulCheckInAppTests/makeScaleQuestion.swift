//
//  makeScaleQuestion.swift
//  MindfulCheckInAppTests
//
//  Created by Shane Bunting on 28/01/2026.
//

import Foundation
import Testing
@testable import MindfulCheckInApp // replace with your app target name

func makeScaleQuestion(topic: QuestionTopic,
                       scoring: ScoringRule? = nil) -> SurveyQuestion {
    SurveyQuestion(
        id: UUID(),
        title: "Test \(topic.displayName)",
        topic: topic,
        inputType: .slider,
        resourceID: nil,
        isEnabled: true,
        backgroundColorName: nil,
        backgroundImageName: nil,
        options: nil,
        scoring: scoring
    )
}
