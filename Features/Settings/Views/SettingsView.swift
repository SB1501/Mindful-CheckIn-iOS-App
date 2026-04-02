// SB - SettingsView
// Controls the settings for the app - question management, notifications, data control and about info.

import Foundation
import SwiftUI
import UniformTypeIdentifiers //used for handling JSON files in functions within this class

//CUSTOM DEFINED LIQUID GLASS STYLE CARD FOR EACH SETTINGS BUTTON / ROW
struct LiquidGlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 20
    @ViewBuilder var content: Content

    var body: some View { //child content that renders inside each card
        content
            .padding() //internal spacing
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)) //Apple's translucent 'material' background with rounded corners
            .overlay( //subtle outline
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous) //rounded corners
                    .stroke(Color.white.opacity(0.25), lineWidth: 1) //outline
            )
            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
    }
} //end of LiquidGlassCard

struct ExportTextDocument: FileDocument { //Document type for exporting to a txt file when used from settings for user data
    static var readableContentTypes: [UTType] { [.plainText] } //declaring support for plain text as a file type
    var text: String //content of document
    init(text: String = "") { self.text = text } //default initialise with nothing inside
    init(configuration: ReadConfiguration) throws { //required to initialise and load from an existing file (survey records)
        if let data = configuration.file.regularFileContents, let string = String(data: data, encoding: .utf8) {
            text = string //decode UTF-8 data into text, or default to an empty on failure:
        } else {
            text = ""
        }
    } //end of load initialiser
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper { //function to write file to disk
        let data = text.data(using: .utf8) ?? Data() //encode text as UTF-8 wrap for export
        return .init(regularFileWithContents: data)
    }
}

//MAIN SETTINGS VIEW SCREEN SHOWN
struct SettingsView: View { //main settings screen defined
    @StateObject private var store = SurveyStore.shared //shared survey data store which is observable
    @State private var showDeleteAllAlert = false //state variable for delete warning
    @State private var showingExportError = false //state variable for showing export error
    @State private var isFileExporterPresented: Bool = false //state variable for export option presented
    @State private var exportDocument = ExportTextDocument() //state variable for holding the actual exported document
    
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false //stored in app memory for simple settings between runs, whether initial welcome has been seen or not (used for reset option below)
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer: Bool = false //same as above but for the initial disclaimer on app start
    // Removed biometric lock storage as per instructions
    @AppStorage("appLockEnabled") var appLockEnabled: Bool = false //stores state of whether or not app lock is enabled by user

    @Environment(\.colorScheme) private var colorScheme //variable stored in the Envirornment determines colour scheme light or dark

    //App Version String Generator - called lower down
    private var appVersionText: String { //variable to hold String of app version
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown" //read the build ersion from the projects info, referencing that key, as a String but if unknown or issue, say unknown
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown" //read build number from project info key but if issues, then say unknown
        return "\(version) (\(build))" //return the version and build in a string
    }

    //Email Me for Feedback Function
    private var feedbackURL: URL? { //define function to hold a URL - in this case, email
        let formatter = DateFormatter() //variable to format dates
        formatter.dateFormat = "yyyy-MM-dd" //specify date using that formatter
        let date = formatter.string(from: Date()) //store that date in a String, from: Date() calls todays date
        let subject = "Mindful Check-in App Feedback - \(date)" //variable for email subject, using date made above
        let email = "sabunting@icloud.com" //variable to hold my email address where feedback is sent
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subject //this is what handles spaces into %20 in a URL ensuring conformance with only allowed characters / percentage used like that
        let urlString = "mailto:\(email)?subject=\(encodedSubject)" // constructs the 'mailto' string including my email, places the subject in so the email open with that already in place
        return URL(string: urlString) //return the overall url string
    }

    private let appReviewURL = URL(string: "https://apps.apple.com/gb/app/mindful-check-in/id6758107607?action=write-review")! //url to App Store, exclamation mark asserts that this is a valid URL since its hard coded and known to be good, it is asserted

    var body: some View { //main View UI drawn on screen
        AppShell { //wrapped in the background AppShell like other views
            ScrollView { //main scrollable list that makes up Settings UI
                VStack(alignment: .leading, spacing: 16) { //vertical stack, everything within follows top to bottom
                    Text("Settings") //title
                        .font(.system(size: 40, weight: .bold)) //styling modifiers
                    Text("Manage your Check-in experience") //sub-title
                        .font(.title3) //styling modifiers
                        .foregroundStyle(.primary)

                    Divider() //spacing under top section
                    
                    // BUTTON Export Data Button Row
                    Button(action: { exportData() }) { //calls function exportData when pressed
                        HStack(spacing: 12) { //horizontal stack, everything within follows left to right
                            ZStack { //zstack, everything within sits on top of the previous item
                                Circle() //circle background, with modifiers for style:
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                Image(systemName: "square.and.arrow.up").font(.title3) //icon itself
                            } //end of logo zstack
                            VStack(alignment: .leading, spacing: 2) { //new VStack for butons title / description text inside
                                Text("Export Data").font(.title2).bold()
                                Text("Save past check-ins to a text file").font(.subheadline).foregroundStyle(.secondary)
                            } //end of internal text vstack, but still inside hstack:
                            Spacer() //space but horizontally since inside hstack still
                            Image(systemName: "chevron.right").foregroundColor(.gray) //icon for right arrow on right side
                        } //end of hstack inside button, styling modifiers below:
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    } //end of button, styling modifier below:
                    .buttonStyle(.plain) //removes a lot of built in styling from a default button

                    // BUTTON - Delete all data
                    Button(role: .destructive) { showDeleteAllAlert = true } label: { //when tapped, presents warning by calling and changing the State variable above, which is used to change UI. Destructive means red alert for something semantically bad or risky to happen if tapped
                        HStack(spacing: 12) { //as above, defining the icon and text / spacing
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                Image(systemName: "trash").font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) { //as above
                                Text("Delete All Data").font(.title2).bold()
                                Text("Removes all past survey information").font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain) //as above

                    // BUTTON - License Info, all as above
                    NavigationLink(destination: LicenseInfoView()) { //instead of calling a function, it used the NavigationStack to call LicenseInfoView which is defined within this class file since it's only an overlay
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                Image(systemName: "doc.text").font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("License Info").font(.title2).bold()
                                Text("MIT License").font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // BUTTON - App Lock Control
                    HStack(spacing: 12) { //as above buttons... but no function just shows info in text
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                )
                            Image(systemName: "lock").font(.title3)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("App Lock").font(.title2).bold()
                            Text("Passcode / Biometric Lock").font(.subheadline).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: $appLockEnabled)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    
                    // BUTTON - App Version
                    HStack(spacing: 12) { //as above buttons... but no function just shows info in text
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                )
                            Image(systemName: "info.circle").font(.title3)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("App Version").font(.title2).bold()
                            Text(appVersionText).font(.subheadline).foregroundStyle(.secondary) //calls the variable defined at the top of the class that reads the apps current version from the project bundle key property
                        }
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )

                    // BUTTON - Review on the App Store
                    Button(action: { UIApplication.shared.open(appReviewURL) }) { //when tapped, goes to the appReviewURL defined above
                        HStack(spacing: 12) { //title defined as above buttons are...
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                Image(systemName: "star").font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Review on the App Store").font(.title2).bold()
                                Text("Tell the world what you think!").font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    // Buy Me a Coffee (REMOVED UNTIL I FIGURE OUT APP STORE ROUTE TO DO THIS)
//                    Button(action: {
//                        if let url = URL(string: "https://buymeacoffee.com/shanebunting") {
//                            UIApplication.shared.open(url)
//                        }
//                    }) {
//                        HStack(spacing: 12) {
//                            ZStack {
//                                Circle()
//                                    .fill(.ultraThinMaterial)
//                                    .frame(width: 44, height: 44)
//                                    .overlay(
//                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
//                                    )
//                                Image(systemName: "cup.and.saucer").font(.title3)
//                            }
//                            VStack(alignment: .leading, spacing: 2) {
//                                Text("Buy Me a Coffee").font(.title2).bold()
//                                Text("Support the apps development").font(.subheadline).foregroundStyle(.secondary)
//                            }
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.gray)
//                        }
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 12, style: .continuous)
//                                .fill(.ultraThinMaterial)
//                        )
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12, style: .continuous)
//                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
//                        )
//                    }
//                    .buttonStyle(.plain)

                    // BUTTON - Send Feedback
                    Button(action: { if let url = feedbackURL { UIApplication.shared.open(url) } }) { //opens the URL defined above where the email address and mailto String is defined and returned
                        HStack(spacing: 12) { //rest of this button is defined as the rest are
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                Image(systemName: "envelope").font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Send Feedback").font(.title2).bold()
                                Text("Tell me what you think!").font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

//                    // BUTTON - Reset Welcome
//                    Button(role: .destructive) { //when pressed, performs a des
//                        hasSeenWelcome = false //sets these so that on next app run they show again
//                        hasAcceptedDisclaimer = false //sets these so that on next app run they show again
//                    } label: {
//                        HStack(spacing: 12) { //title and description as on other buttons
//                            ZStack {
//                                Circle()
//                                    .fill(.ultraThinMaterial)
//                                    .frame(width: 44, height: 44)
//                                    .overlay(
//                                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
//                                    )
//                                Image(systemName: "arrow.counterclockwise").font(.title3)
//                            }
//                            VStack(alignment: .leading, spacing: 2) {
//                                Text("Reset Welcome").font(.title2).bold()
//                                Text("Restore Welcome Screen on next start").font(.subheadline).foregroundStyle(.secondary)
//                            }
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.gray)
//                        }
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 12, style: .continuous)
//                                .fill(.ultraThinMaterial)
//                        )
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12, style: .continuous)
//                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
//                        )
//                    }
//                    .buttonStyle(.plain)

                }
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 115/255, green: 255/255, blue: 255/255),
                        Color(red: 0/255, green: 251/255, blue: 207/255)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(colorScheme == .light ? 0.44 : 0.36)
                .blendMode(colorScheme == .light ? .overlay : .plusLighter)
                .ignoresSafeArea()
            )
        } //END OF AppShell WRAPPER
        
        //These state modifiers control the alert dialogs and what each buttons do, which are all presented based off of pressing of the buttons defined above:
        .alert("Delete All Data?", isPresented: $showDeleteAllAlert) { //triggers the alert to show the warning before deleting
            Button("Cancel", role: .cancel) {} //do nothing, button defined
            Button("Delete", role: .destructive) { //perform action, button defined
                store.removeAll() //function call which removes all stored data within app (from SurveyStore Class)
            }
        }
        .alert("Export Failed", isPresented: $showingExportError) { //triggers error if needed
            Button("OK", role: .cancel) {} //defines buttons
        } message: {
            Text("We couldn't export your data. Please try again.") //defines message
        }
        .fileExporter( //when fileExporter is called...
            isPresented: $isFileExporterPresented, //change this property, shows modal selection of where to save file to user when true
            document: exportDocument, //store the exported document HERE
            contentType: .plainText, //defines type of file output
            defaultFilename: defaultExportFilename //
        ) { result in
            if case .failure(_) = result { showingExportError = true } //set error flag if issues encountered
        }
    } //end of main Settings UI body view


    //PRIVATE TO THIS CLASS FUNCTION METHODS TO SUPPORT ACTIONS BUTTONS PERFORM ABOVE:

    private func exportData() {
        let text = buildExportText() //variable to hold exported text
        exportDocument = ExportTextDocument(text: text) //to hold exported document as a text document
        isFileExporterPresented = true //variable set when exporter is presented, the modal sheet pop up to choose where to save a file
    }

    private var defaultExportFilename: String { //defines filename of file exported
        let formatter = DateFormatter() //variable to hold date formatter data
        formatter.dateFormat = "yyyy-MM-dd_HH-mm" //defines format in formatter
        return "MindfulCheckinExport_\(formatter.string(from: Date())).txt" //returns default text but slips in the current date in the format we told it to
    }

        private func buildExportText() -> String { //main function that returns exported data when called
        var lines: [String] = [] //accumulates strings in an Array
        lines.append("Mindful Check-in Export") //appends to that array with title
        lines.append(Date().formatted(date: .abbreviated, time: .standard)) //appends the formatted date and time of export to that array
        lines.append("Total records: \(store.records.count)") //counts the number of records in store (survey count)
        lines.append("") //appends a new blank line
        let df = DateFormatter() //initialise a DateFormatter variable to store date in
        df.dateStyle = .medium //define date style
        df.timeStyle = .short //define time style
        for record in store.records { //FOR LOOP - each iteration is for one survey, repeats per survey in store...
            lines.append("=== Record ===") //title
            lines.append("Date: \(df.string(from: record.date))") //date
            lines.append("Summary: Good \(record.summary.good) • Neutral \(record.summary.neutral) • Needs Attention \(record.summary.bad)") //summary, with a count of 'good bad neutral' topics for that survey
            let note = record.reflection.trimmingCharacters(in: .whitespacesAndNewlines) // stores reflection note data
            lines.append("Reflection: \(note.isEmpty ? "-" : note)") //handles empty string which is allowed
            if !record.positiveTopics.isEmpty { //ONLY IF NOT EMPTY ...
                lines.append("Doing well on: " + record.positiveTopics.map { $0.displayName }.joined(separator: ", ")) //list the topic, separate with comma, on to next...
            }
            if !record.neutralTopics.isEmpty { //ONLY IF NOT EMPTY...
                lines.append("Okay on: " + record.neutralTopics.map { $0.displayName }.joined(separator: ", ")) //list the topic, separate with comma, on to next...
            }
            if !record.flaggedTopics.isEmpty { //ONLY IF NOT EMPTY...
                lines.append("Mindful of: " + record.flaggedTopics.map { $0.displayName }.joined(separator: ", ")) //list the topic, separate with comma, on to next...
            }
            lines.append("") //blank line at end...
        } //end of FOR LOOP per survey record.
            
        return lines.joined(separator: "\n") //returns the final text
    }
    
} //end of SettingsView main struct

// MARK: - SUBVIEWS USED IN SETTINGS

struct LicenseInfoView: View { //view presented when LicenseInfoView is called, in modal form
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.appAccent.opacity(0.85), Color.appAccent.opacity(0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 64, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8)
                        .padding(.top, 24)

                    Text("License")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("This project is open for reuse as a portfolio piece with real‑world utility. You’re welcome to read the code, learn from it, and reuse it in your own projects under the terms of the MIT License. The full code can be found on GitHub (SB1501).")

                        Group {
                            Text("License: MIT License")
                                .font(.headline)
                            Text("A permissive open‑source license allowing reuse with attribution")
                                .foregroundStyle(.secondary)
                            Text("Summary")
                                .font(.headline)
                            Text("• You may use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software.")
                            Text("• Attribution is appreciated by including the copyright notice and license text in copies or substantial portions of the software.")
                            Text("• The software is provided without warranty of any kind.")
                        }

                        Group {
                            Text("Notes")
                                .font(.headline)
                            Text("MIT is a widely used, OSI‑approved license that enables broad reuse, including commercial use. This aligns with your intent to make the project freely reusable as part of your portfolio.")
                        }

                        Group {
                            Text("No warranty")
                                .font(.headline)
                            Text("THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.")
                        }

                        Group {
                            Text("Commercial use")
                                .font(.headline)
                            Text("Commercial use is permitted under the MIT License. If you use this project, attribution is appreciated.")
                        }

                        Group {
                            Text("Learn more")
                                .font(.headline)
                            if let url = URL(string: "https://opensource.org/license/mit/") {
                                Link("MIT License (opensource.org)", destination: url)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                }
                .padding()
            }
        }
    }
} //end of LicenseInfoView


#Preview {
    SettingsView()
}

