import SwiftUI
import UniformTypeIdentifiers

struct DataPrivacyView: View {
    @State private var showDeleteConfirmation = false
    @State private var exportFileURL: URL?
    @State private var isSharePresented = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button("Export Data") {
                        exportData()
                    }
                    .disabled(isSharePresented && exportFileURL == nil)
                    .sheet(isPresented: $isSharePresented, onDismiss: {
                        cleanupExportFile()
                    }) {
                        if let url = exportFileURL {
                            ActivityView(activityItems: [url])
                        }
                    }

                    Button("Delete All Data") {
                        showDeleteConfirmation = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Data & Privacy")
            .alert("Delete All Data?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    deleteAllData()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete all data? This action cannot be undone.")
            }
        }
    }

    func exportData() {
        let sampleData = """
        Name: John Doe
        Email: john@example.com
        Joined: 2020-01-15

        Name: Jane Smith
        Email: jane@example.com
        Joined: 2021-05-23
        """

        do {
            let url = try createExportFile(with: sampleData)
            exportFileURL = url
            isSharePresented = true
        } catch {
            print("Failed to create export file: \(error)")
        }
    }

    func createExportFile(with content: String) throws -> URL {
        let fileName = "ExportedData_\(Date().formatted(.iso8601)).txt"
        let documentsDir = FileManager.default.temporaryDirectory
        let fileURL = documentsDir.appendingPathComponent(fileName)
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }

    func cleanupExportFile() {
        if let url = exportFileURL {
            try? FileManager.default.removeItem(at: url)
            exportFileURL = nil
        }
        isSharePresented = false
    }

    func deleteAllData() {
        // Placeholder for actual data deletion logic
        print("All data deleted.")
    }
}

struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    DataPrivacyView()
}
