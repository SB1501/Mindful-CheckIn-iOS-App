// DevSeeder.swift
// Debug-only utilities to seed the app with dummy data for development and testing.

import Foundation

#if DEBUG

enum DevSeeder {
    /// Seeds the SurveyStore with a number of dummy SurveyRecord entries.
    /// - Parameters:
    ///   - count: Number of records to create.
    ///   - overwrite: If true, clears existing records first.
    static func seedDummyData(count: Int = 50, overwrite: Bool = false) {
        let store = SurveyStore.shared

        if overwrite { store.removeAll() }
        // If not overwriting and there is already data, do nothing.
        if !overwrite && !store.records.isEmpty { return }

        var records: [SurveyRecord] = []
        let topics = Array(QuestionTopic.allCases)
        let now = Date()

        for _ in 0..<count {
            // Spread records across the last ~120 days at random times
            let daysAgo = Int.random(in: 0...120)
            let secondsOffset = TimeInterval(Int.random(in: 0..<86400))
            let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: now)!
                .addingTimeInterval(-secondsOffset)

            // Random topic buckets with a natural-looking distribution
            let shuffled = topics.shuffled()
            let goodCount = Int.random(in: 3...8)
            let neutralCount = Int.random(in: 1...6)
            let badCount = Int.random(in: 0...4)

            let positive = Array(shuffled.prefix(goodCount))
            let neutral = Array(shuffled.dropFirst(goodCount).prefix(neutralCount))
            let flagged = Array(shuffled.dropFirst(goodCount + neutralCount).prefix(badCount))

            let reflections = [
                "Felt pretty balanced today — a few rough patches, but manageable.",
                "Noticed tension creeping in; tried a short walk which helped.",
                "Better hydration and sleep made a big difference.",
                "A bit overwhelmed; planning lighter tasks tomorrow.",
                "Small wins add up. Keep going.",
                "Mood lifted after spending time outdoors.",
                "Cutting back caffeine helped with sleep.",
                "Taking short breaks improved focus this afternoon."
            ]
            let reflection = Bool.random() ? reflections.randomElement()! : ""

            let summary = SurveySummary(
                good: positive.count,
                neutral: neutral.count,
                bad: flagged.count
            )

            let record = SurveyRecord(
                date: date,
                summary: summary,
                reflection: reflection,
                positiveTopics: positive,
                neutralTopics: neutral,
                flaggedTopics: flagged
            )

            records.append(record)
        }

        // Newest first
        records.sort { $0.date > $1.date }

        // Persist via SurveyStore API (didSet will save to UserDefaults)
        for record in records.reversed() {
            store.add(record)
        }
    }
}

#endif

