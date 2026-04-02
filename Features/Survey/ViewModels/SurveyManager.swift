// SB - SurveyManager
// Coordinates the data model, question loading, skipping and counting for end summary.

import Foundation
import SwiftUI
import Combine

class SurveyManager: ObservableObject { //CLASS DEFINITION
    @Published var questions: [SurveyQuestion] = [] //Observable array of all questions lodaded for survey, publishes changes to SwiftUI Views
    @Published var responses: [SurveyResponse] = [] //Observable array of user responses including skipped, drives UI updates
    @Published var currentIndex: Int = 0 //Observable array of current index, default at 0 position

    var reflectionNote: String = "" //text variablestorage for reflection notes
    var session = SurveySession(id: UUID(), date: Date(), responses: []) //session metadata for a given survey instance

    
    func loadQuestions() { //LOADING QUESTIONS
        guard let url = Bundle.main.url(forResource: "sampleQuestions", withExtension: "json") else { //look up the URL for sampleQuestions.json, but if not found ELSE executes
            print("sampleQuestions.json not found in bundle.") //if the file isn't found, print that as an error log in the console
            self.questions = [] //clear questions to a known empty state
            return //early exit if file does not exist
        } //end of if file missing block
        do {
            let data = try Data(contentsOf: url) //reads the contents of the JSON file into memory
            let decoded = try JSONDecoder().decode([SurveyQuestion].self, from: data) //decodes the JSON into an array of SurveyQyestion
            self.questions = decoded //stores decoded questions
        } catch { //any errors in reading/decoding are caught here:
            print("Failed to decode sampleQuestions.json: \(error)") //printed to console log
            self.questions = [] //falls back to an empty question list if it went wrong
        }

        // RESET STATE FOR FRESH RUN OF QUESTIONS LOADING
        self.responses = [] //clears any previous repsonses gathered
        self.currentIndex = 0 //resets index to 0
        self.session = SurveySession(id: UUID(), date: Date(), responses: []) //fresh ID and metadata
    }

    
    func recordResponse(for question: SurveyQuestion, answer: AnswerValue) { //RECORDS OR REPLACES A RESPONSE FOR A QUESTION ANSWERED

        //remove any existing response for this question (including a previous skip)
        if let idx = responses.firstIndex(where: { $0.questionID == question.id }) { //finds an existing response for the same question
            responses.remove(at: idx) //removes the previous response to avoid duplicates
        }

        //add the new response
        let response = SurveyResponse( //construct a new response object (not skipped) with metadata
            id: UUID(),
            questionID: question.id,
            answer: answer,
            timestamp: Date(),
            wasSkipped: false
        )
        responses.append(response) //append to the record for the list forming this survey

        //ensure the topic appears in exactly one category: remove from all, then add to the new one
        removeTopicFromAllCategories(question.topic) //calls method to remove questions topic from all session categories before re-assigning

        let cat = category(for: answer, question: question) //compute which category (negative/neutral/positive) this answer falls into
        switch cat { //SWITCH to compute category this falls under
        case .negative:
            session.flaggedTopics.append(question.topic) //add topic to this category .. same below
        case .neutral:
            session.neutralTopics.append(question.topic)
        case .positive:
            session.positiveTopics.append(question.topic)
        } //end of SWITCH
    }

    
    func skipQuestion() { //SKIP QUESTION
        guard currentIndex < questions.count else { return } //check current index survey question position is within bounds
        let question = questions[currentIndex] //retrieve current question

        //remove any existing response for this question
        if let idx = responses.firstIndex(where: { $0.questionID == question.id }) {
            responses.remove(at: idx) //removes any current response if one exists or was tapped before pressing Skip
        }

        //record the skip
        let skipped = SurveyResponse( //constructs a skipped response using .scale(0) as a sentinel value
            id: UUID(),
            questionID: question.id,
            answer: .scale(0),
            timestamp: Date(),
            wasSkipped: true
        )
        responses.append(skipped) //appends this to the list that forms the record for this survey

        //remove the topic from all categories since it's skipped
        removeTopicFromAllCategories(question.topic)

        advance() //calls function to move forward to the next question
    }//end of skippedQuestion

    
    func goBack() { //BACK BUTTON FUNCTION
        if currentIndex > 0 { //increment current index down by one, but not if on first question (0)
            currentIndex -= 1
        }
    }

    
    func advance() { //NEXT BUTTON FUNCTIONALITY
        if currentIndex < questions.count { //checks not at the end of the total number of questions
            currentIndex += 1 //if so, advance by 1
        }
        print("Current index: \(currentIndex) / \(questions.count)") //prints to console to confirm action
    }
    

    private func removeTopicFromAllCategories(_ topic: QuestionTopic) { //REMOVES A CATEGORY POSITIVE/NEUTRAL/NEGATIVE WHEN CALLED
        session.flaggedTopics.removeAll { $0 == topic } //$0 means current question index
        session.neutralTopics.removeAll { $0 == topic } //these remove it from topic
        session.positiveTopics.removeAll { $0 == topic }
    }
    
    
    func generateSession() -> SurveySession { //FINALISE AND RETURN CURRENT SESSION SNAPSHOT
        session.responses = responses //stores data in responses
        session.reflectionNote = reflectionNote //stores reflectionNote
        return session //returns stored data in a session (SurveySession) object
    }
    
    //SCORING LOGIC - determines if an answer is POSITIVE / NEUTRAL / NEGATIVE
    func category(for answer: AnswerValue, question: SurveyQuestion) -> AnswerCategory {
        
        //prefer per-question scoring rules if present
        if let rule = question.scoring { //checks for a ScoringRule
            
            switch answer { //branches on SWITCH depend on slider/scale or button/choice
                
            case .scale(let value): //numeric slider answers
                let higherIsBetter = rule.higherIsBetter ?? true //defaults to higherIsBetter

                if let max = rule.flaggedMaxScale { //MAX ANSWERS
                    if higherIsBetter, value <= max { return .negative } //less than max, negative
                    if !higherIsBetter, value >= max { return .negative } //more than max, negative
                }
                if let min = rule.positiveMinScale { //MIN ANSWERS
                    if higherIsBetter, value >= min { return .positive } //more than min, positive
                    if !higherIsBetter, value <= min { return .positive } //less than min, negative
                }
                //if thresholds are provided, anything in-between is neutral
                if rule.flaggedMaxScale != nil || rule.positiveMinScale != nil {
                    return .neutral //mark as neutral if not fully negative / positive above
                }
                
            case .choice(let value): //button choice answers
                if let negatives = rule.flaggedChoices, negatives.contains(value) { return .negative }
                if let positives = rule.positiveChoices, positives.contains(value) { return .positive }
                if let neutrals = rule.neutralChoices, neutrals.contains(value) { return .neutral }
            }
        }

        // default behavior
        switch answer { //branches for slider/scale or button/choice
            
        case .scale(let value): //SLIDER
            if value >= 4 { return .positive }
            if value == 3 { return .neutral }
            return .negative
            
        case .choice(let value): //BUTTON (future ref: add more wordings here)
            if value == "Plenty" || value == "High" { return .positive }
            if value == "Some" || value == "Medium" { return .neutral }
            return .negative // e.g., "None", "Low"
        }
    }
    
    //THESE FINAL FUNCTION METHODS ARE NO LONGER NEEDED, TO BE REMOVED IN FUTURE VERSION IF NO ISSUES DISCOVERED
    
//    func isFlagged(_ answer: AnswerValue, for question: SurveyQuestion) -> Bool {
//        if let rule = question.scoring { //RECORDS IF IT'S HIGHLY NEGATIVE 'flagged'
//            
//            switch answer {
//            case .scale(let value):
//                if let max = rule.flaggedMaxScale { return value <= max }
//            case .choice(let value):
//                if let flagged = rule.flaggedChoices { return flagged.contains(value) }
//            }
//        }
//        //default behavior for when no rule is defined:
//        switch answer {
//        case .scale(let value): return value <= 2
//        case .choice(let value): return value == "None" || value == "Low"
//        }
//    }
//
//    func isPositive(_ answer: AnswerValue, for question: SurveyQuestion) -> Bool {
//        if let rule = question.scoring {
//            switch answer {
//            case .scale(let value):
//                if let min = rule.positiveMinScale { return value >= min }
//            case .choice(let value):
//                if let positive = rule.positiveChoices { return positive.contains(value) }
//            }
//        }
//        //default behavior for when no rule is defined:
//        switch answer {
//        case .scale(let value): return value >= 4
//        case .choice(let value): return value == "Plenty" || value == "High"
//        }
//    }
//
//    func isNeutral(_ answer: AnswerValue, for question: SurveyQuestion) -> Bool {
//        if let rule = question.scoring {
//            switch answer {
//            case .scale(let value):
//                if let min = rule.positiveMinScale, let max = rule.flaggedMaxScale {
//                    return value > max && value < min
//                }
//            case .choice(let value):
//                if let neutral = rule.neutralChoices { return neutral.contains(value) }
//            }
//        }
//        //default behavior for when no rule is defined:
//        switch answer {
//        case .scale(let value): return value == 3
//        case .choice(let value): return value == "Some" || value == "Medium"
//        }
//    }
    
}
