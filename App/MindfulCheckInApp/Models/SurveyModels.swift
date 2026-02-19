//SB - SurveyModels
// Data Model for this app (major work in progress) questions, associated sentences to support 

import Foundation


//SurveyQuestion
enum QuestionTopic: String, Codable, CaseIterable, Hashable {
case sleep, hydration, food, caffeine, sugar
case rest, hygiene, strain, clothing
case eyes, temperature, lighting, sound
case socialising, outdoors, space, screenTime
case tension, breathing
case mentalBusy, taskLoad, mentalBreak
case focus, avoidance, motivation
case selfCheckIn, selfKindness, authenticity

var positiveSummary: String {
    switch self {
    case .sleep: return "You're well-rested today."
    case .hydration: return "You're staying hydrated."
    case .food: return "You've nourished yourself well."
    case .caffeine: return "Your caffeine intake seems balanced."
    case .sugar: return "Your sugar levels are in check."
    case .rest: return "You've given yourself time to rest."
    case .hygiene: return "You've taken care of your hygiene."
    case .strain: return "Your body feels free of strain."
    case .clothing: return "Your clothing feels comfortable."
    case .eyes: return "Your eyes feel fine today."
    case .temperature: return "The temperature feels just right."
    case .lighting: return "Lighting isn't bothering you."
    case .sound: return "Sounds around you feel manageable."
    case .socialising: return "You've had meaningful social contact."
    case .outdoors: return "You've spent time outdoors."
    case .space: return "Your space feels tidy and calm."
    case .screenTime: return "Your screen time feels balanced."
    case .tension: return "Your body feels relaxed."
    case .breathing: return "Your breathing feels steady."
    case .mentalBusy: return "Your mind feels calm and focused."
    case .taskLoad: return "You're managing your tasks well."
    case .mentalBreak: return "You've taken mental breaks."
    case .focus: return "You're able to concentrate clearly."
    case .avoidance: return "You're facing things head-on."
    case .motivation: return "You're feeling motivated."
    case .selfCheckIn: return "You've checked in with yourself."
    case .selfKindness: return "You're being kind to yourself."
    case .authenticity: return "You're staying true to your needs."
    }
}

var flaggedSummary: String {
    // message for when this topic was flagged by a low score
    return "This area may need attention."
}

var neutralSummary: String {
    // message for when this topic is neither flagged nor strongly positive
    return "This area seems okay today."
}

var displayName: String {
    switch self {
    case .sleep: return "Sleep"
    case .hydration: return "Hydration"
    case .food: return "Food"
    case .caffeine: return "Caffeine"
    case .sugar: return "Sugar"
    case .rest: return "Rest"
    case .hygiene: return "Hygiene"
    case .strain: return "Strain"
    case .clothing: return "Clothing"
    case .eyes: return "Eyes"
    case .temperature: return "Temperature"
    case .lighting: return "Lighting"
    case .sound: return "Sound"
    case .socialising: return "Socialising"
    case .outdoors: return "Outdoors"
    case .space: return "Space"
    case .screenTime: return "Screen Time"
    case .tension: return "Tension"
    case .breathing: return "Breathing"
    case .mentalBusy: return "Mental Calmness"
    case .taskLoad: return "Task Load"
    case .mentalBreak: return "Mental Break"
    case .focus: return "Focus"
    case .avoidance: return "Avoidance"
    case .motivation: return "Motivation"
    case .selfCheckIn: return "Self Check-In"
    case .selfKindness: return "Self-Kindness"
    case .authenticity: return "Authenticity"
    }
}

var symbolName: String {
    switch self {
    case .sleep: return "bed.double.fill"
    case .hydration: return "drop.fill"
    case .food: return "fork.knife"
    case .caffeine: return "cup.and.saucer.fill"
    case .sugar: return "cube.fill"
    case .rest: return "pause.circle.fill"
    case .hygiene: return "shower.fill"
    case .strain: return "figure.cooldown"
    case .clothing: return "tshirt.fill"
    case .eyes: return "eye.fill"
    case .temperature: return "thermometer.sun.fill"
    case .lighting: return "lightbulb.fill"
    case .sound: return "speaker.wave.2.fill"
    case .socialising: return "person.2.fill"
    case .outdoors: return "leaf.fill"
    case .space: return "square.grid.2x2.fill"
    case .screenTime: return "display"
    case .tension: return "figure.strengthtraining.traditional"
    case .breathing: return "lungs.fill"
    case .mentalBusy: return "brain.head.profile"
    case .taskLoad: return "checklist"
    case .mentalBreak: return "hourglass"
    case .focus: return "scope"
    case .avoidance: return "figure.walk.departure"
    case .motivation: return "bolt.fill"
    case .selfCheckIn: return "person.crop.circle.badge.checkmark"
    case .selfKindness: return "heart.fill"
    case .authenticity: return "staroflife.fill"
    }
}
}

enum InputType: String, Codable {
    case slider, buttonGroup
}

struct SurveyQuestion: Identifiable, Codable {
    let id: UUID
    let title: String
    let topic: QuestionTopic
    let inputType: InputType
    var isEnabled: Bool
    var backgroundColorName: String?
    let options: [String]?
    var scoring: ScoringRule? // Optional per-question scoring rules
}

struct ScoringRule: Codable {
    // For button groups: define which choices count toward each category
    var positiveChoices: [String]?
    var neutralChoices: [String]?
    var flaggedChoices: [String]?

    // For sliders: thresholds to classify values (inclusive)
    // Example: flaggedMaxScale = 2 means 1...2 are flagged; positiveMinScale = 4 means 4...5 are positive
    var flaggedMaxScale: Int?
    var positiveMinScale: Int?

    // If false, higher values are worse (e.g., more sugar/caffeine is negative). Defaults to true when nil.
    var higherIsBetter: Bool?
}

//SurveyResponse
enum AnswerValue: Codable {
    case scale(Int)        // e.g. 1–5 slider
    case choice(String)    // e.g. “Some” / “Plenty”
}

enum AnswerCategory: String, Codable {
    case positive, neutral, negative
}

struct SurveyResponse: Identifiable, Codable {
    let id: UUID
    let questionID: UUID
    let answer: AnswerValue
    let timestamp: Date
    let wasSkipped: Bool //for survey progress indicator dots
}

//SurveySession
struct SurveySession: Identifiable, Codable {
    let id: UUID
    let date: Date
    var responses: [SurveyResponse]
    var reflectionNote: String?

    var flaggedTopics: [QuestionTopic] = []
    var neutralTopics: [QuestionTopic] = []
    var positiveTopics: [QuestionTopic] = []
}

//ResourcePage
struct ResourcePage: Identifiable, Codable {
    let id: UUID
    let title: String
    let summary: String
    let benefits: [String]
    let considerations: [String]   // What happens if neglected
    let tips: [String]
}

//AppSettings
enum AppTheme: String, Codable {
    case system, light, dark
}

struct AppSettings: Codable {
    var notificationEnabled: Bool
    var reminderTime: Date?
    var theme: AppTheme
    var questionOrder: [UUID]     // Custom ordering from Settings
}

