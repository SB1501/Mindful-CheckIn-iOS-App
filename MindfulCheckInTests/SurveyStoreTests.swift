import Testing
@testable import MindfulCheckInApp
import Foundation

@Suite("SurveyStore behavior")
struct SurveyStoreTests {

    @MainActor
    @Test("Add and remove records without touching real UserDefaults")
    func addAndRemove() throws {
        let suiteName = "TestSuite-SurveyStore-AddRemove"
        let defaults = try #require(UserDefaults(suiteName: suiteName))
        // Clean the suite so we don't leak state across runs
        defaults.removePersistentDomain(forName: suiteName)

        let store = SurveyStore(userDefaults: defaults, storageKey: "testRecords")
        #expect(store.records.isEmpty)

        let record = SurveyRecord(
            date: Date(),
            summary: SurveySummary(good: 1, neutral: 0, bad: 1),
            reflection: "Test",
            positiveTopics: [.sleep],
            neutralTopics: [],
            flaggedTopics: [.screenTime]
        )

        store.add(record)
        #expect(store.records.first == record)

        store.remove(record)
        #expect(store.records.isEmpty)

        store.removeAll()
        #expect(store.records.isEmpty)
    }

    @MainActor
    @Test("Round-trip persistence using injected UserDefaults suite")
    func roundTripPersistence() throws {
        let suiteName = "TestSuite-SurveyStore-RoundTrip"
        let defaults = try #require(UserDefaults(suiteName: suiteName))
        defaults.removePersistentDomain(forName: suiteName)

        // First instance writes
        do {
            let store = SurveyStore(userDefaults: defaults, storageKey: "testRecords")
            #expect(store.records.isEmpty)
            let r1 = SurveyRecord(
                date: Date(),
                summary: SurveySummary(good: 2, neutral: 1, bad: 0),
                reflection: "Persist A",
                positiveTopics: [.sleep, .hydration],
                neutralTopics: [.space],
                flaggedTopics: []
            )
            store.add(r1)
            #expect(store.records.count == 1)
        }

        // New instance reads
        do {
            let store = SurveyStore(userDefaults: defaults, storageKey: "testRecords")
            #expect(store.records.count == 1)
            #expect(store.records.first?.reflection == "Persist A")
        }
    }
}
