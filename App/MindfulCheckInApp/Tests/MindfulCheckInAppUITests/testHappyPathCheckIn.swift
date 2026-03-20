//
//  testHappyPathCheckIn.swift
//  MindfulCheckInAppTests
//
//  Created by Shane Bunting on 28/01/2026.
//

import Foundation
import XCTest

final class AppUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testHappyPathCheckIn() {
        // Tap "Check In" on the main menu
        if app.buttons["Check In"].exists {
            app.buttons["Check In"].tap()
        } else if app.staticTexts["Check In"].exists {
            app.staticTexts["Check In"].tap() // fallback if exposed as static text
        } else {
            XCTFail("Could not find 'Check In' on main menu")
        }

        // Loop: skip questions until the summary button shows up
        let summaryButton = app.buttons["View your check-in summary"] // matches your accessibilityLabel
        let skipButton = app.buttons["Skip"]
        let nextButton = app.buttons["Next"]

        let overallTimeout: TimeInterval = 30
        let start = Date()

        while !summaryButton.exists && Date().timeIntervalSince(start) < overallTimeout {
            if skipButton.waitForExistence(timeout: 1), skipButton.isHittable {
                skipButton.tap()
            } else if nextButton.waitForExistence(timeout: 1), nextButton.isHittable {
                // If "Next" is enabled (e.g., if a question was already answered), use it
                nextButton.tap()
            } else {
                // Small wait to allow UI to update
                RunLoop.current.run(until: Date().addingTimeInterval(0.3))
            }
        }

        XCTAssertTrue(summaryButton.waitForExistence(timeout: 5), "Summary button did not appear")
        summaryButton.tap()

        let finishButton = app.buttons["Finish & Save"]
        XCTAssertTrue(finishButton.waitForExistence(timeout: 5), "'Finish & Save' not found on summary screen")
        finishButton.tap()
    }
}
