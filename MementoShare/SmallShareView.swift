import SwiftUI
import SwiftData
import LinkPresentation
import UniformTypeIdentifiers

struct SmallShareView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var notetext: String = ""
    @State private var linkText = ""
    @State private var cancelTask = false
    @State private var tapped = false // State variable to track tap
    
    let note: String?
    let extensionContext: NSExtensionContext?
    let url: URL?
    var isTapped: (() -> Void)?
    
    private let linkprovider = LPMetadataProvider()
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(.systemBackground)
        
            VStack(alignment: .center) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.title)
                Text("Item Saved")
                    .font(.title)
                Text("Tap to edit")
                    .bold()
            }
            .padding()
        }
        .frame(width: 200, height: 200)
        .onAppear {
            if let note = note {
                notetext = note
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
            saveItem()
        }
        .onTapGesture {
            tapped = true
            cancelTask = true
            isTapped?()
        }
    }
    
    private func saveItem() {
        Task {
            if cancelTask {
                return
            }
            if let item = await Item(link: url?.absoluteString ?? linkText, note: notetext) {
                if cancelTask {
                    return
                }
                modelContext.insert(item)
                try? modelContext.save() // Saving the item in SwiftData
                UpdateAll()
                print("Saved")
                extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
    }
}
