## Overview of Interfaces

### 1. Welcome Screen

* App title
* Short intro paragraph (what this app is for)
* Button: “Let’s Go”

### 2. Disclaimer Screen

* Brief disclaimer text (non-medical, self-check only)
* Button: “I Understand”


### 3. Permissions Screen

* Explanation of notification use (daily reminder)
* Button: “Enable Notifications”
* Optional: “Skip for now”


### 4. Main Menu

* Buttons:
  * “Check In” → starts survey
  * “Resources” → info pages
  * “Past Records” → history & trends
  * “Settings” → toggle questions, reminders, etc.


### 5. Survey Flow View (One Question per Screen)

Each screen includes:

* Question Title (prominent)
* Background image or color (based on question type)
* Answer Input:* Button group (e.g. Yes / No / Some)
* Or slider (e.g. Too little → Enough → Too much)

* Proceed Button: appears after answer selected
* Back Button (top left)
* Skip Button (top right)
* More Info Button → opens relevant resource
* Progress Dots:
  * Filled = answered
  * Large = current
  * Hollow = upcoming
  * Grey = skipped


### 6. Survey Completion Screen

Section 1: “Things to Be Mindful Of”
* List of flagged areas (based on low/negative input)
* Each row tappable → shows:
  * Why it matters
  * How it might affect mood
  * Tips to improve


Section 2: “Things You’re Doing Well” 
* Collapsible row → expands to show positive responses
* Encouraging tone

* Buttons:
  * “Back” (top left)
  * “Finish & Save” → stores survey entry

### 7. Resources Screen

Resources

* List of topics (e.g. Sleep, Hydration, Breathing)
* Each opens a short info page with:
  * What it is
  * Why it matters
  * Tips



### 8 . Past Records (completed check in surveys)
* List of previous surveys (date-stamped)
* Tap to view:
  * Responses
  * Mindful areas
  * Positive areas
  * Trend graph or heatmap (something visual)


### 9. Settings

* Toggle questions on/off
* Manage reminder notifications
  * Set daily reminder time
  * Set reminder frequency
* Export data (future feature)
* App version / license info
* Rate on App Store
* Share Link
* Feedback to SB1501

---

Design Details so far...
* Colour-coded tags for question types
* Generous spacing in keeping this a gentle, mindful app, not a productivity tool
* SF Symbols for some generic icons (checkmark, info, dots)
* Custom icons / royalty free graphics for question topics 
* Planning to use NavigationStack in SwiftUI for clean transitions


## Future Screens

* Daily Reminder Setup Screen
* Affirmations Screen
* Export / Backup Screen, for saving survey history (JSON or PDF)
* Onboarding Tips Screen, optional walkthrough for first-time users
* Custom Question Builder, considering this, not sure
* Streak Tracker / Calendar View, visual motivation for consistent check-ins