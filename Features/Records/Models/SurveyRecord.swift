import Foundation
import SwiftUI
import Combine

// Represents a single completed survey that the user can review later.
struct SurveyRecord: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date // completion date/time
    var summary: SurveySummary // what was good/neutral/bad
    var reflection: String // the free-text note from the summary screen
    
    var positiveTopics: [QuestionTopic]
    var neutralTopics: [QuestionTopic]
    var flaggedTopics: [QuestionTopic]
}

// Simple summary bucket for good/neutral/bad counts or selection
struct SurveySummary: Codable, Equatable {
    var good: Int
    var neutral: Int
    var bad: Int
}

// A lightweight store that persists survey records in UserDefaults via JSON.
@MainActor
final class SurveyStore: ObservableObject {
    static let shared = SurveyStore()

    @Published private(set) var records: [SurveyRecord] = [] {
        didSet { save() }
    }

    // FOR TESTING PERSISTENCE: injected dependencies (with defaults)
    private let userDefaults: UserDefaults
    private let storageKey: String

    // FOR TESTING PERSISTENCE: convenience init keeps old behaviour for the app
    init(userDefaults: UserDefaults = .standard, storageKey: String = "surveyRecordsJSON") {
        self.userDefaults = userDefaults
        self.storageKey = storageKey
        load()
    }

    func add(_ record: SurveyRecord) {
        records.insert(record, at: 0) // newest first
    }

    func remove(_ record: SurveyRecord) {
        records.removeAll { $0.id == record.id }
    }

    func removeAll() {
        records.removeAll()
    }

    private func load() {
        guard let data = userDefaults.data(forKey: storageKey) else { return } // use injected
        do {
            let decoded = try JSONDecoder().decode([SurveyRecord].self, from: data)
            self.records = decoded
        } catch {
            //if decoding fails, start fresh:
            self.records = []
        }
    }
    
    

    private func save() {
        do {
            let data = try JSONEncoder().encode(records)
            userDefaults.set(data, forKey: storageKey) // use injected
        } catch {
            // Ignore save errors in this lightweight store
        }
    }

    
}

