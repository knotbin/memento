//  ShareView.swift
//  ShareSheet
//
//  Created by Roscoe Rubin-Rottenberg on 5/28/24.
//

import SwiftUI
import SwiftData
import LinkPresentation
import UniformTypeIdentifiers

struct ShareView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var notetext: String = ""
    @State private var linkText = ""
    @State private var alertPresented = false
    @FocusState private var focus
    
    private let note: String?
    private let extensionContext: NSExtensionContext?
    private let url: URL?
    private let linkprovider = LPMetadataProvider()
    
    var body: some View {
        NavigationStack {
            Form {
                if let url = url {
                    Text(url.absoluteString)
                        .lineLimit(1)
                } else {
                    TextField("Link", text: $linkText)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                }
                Section("Note") {
                    TextEditor(text: $notetext)
                        .focused($focus)
                        .onAppear { focus = true }
                }
            }
            .onSubmit {
                saveItem()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveItem()
                    }
                }
            }
            .navigationTitle("New Item")
            .toolbarTitleDisplayMode(.inline)
            .onAppear {
                if let note = note {
                    notetext = note
                }
            }
        }
        .alert(isPresented: $alertPresented) {
            Alert(title: Text("An error occurred"))
        }
    }
    
    init(extensionContext: NSExtensionContext?, url: URL? = nil, note: String? = nil) {
        self.extensionContext = extensionContext
        self.url = url
        self.note = note ?? ""
    }
    
    private func saveItem() {
        Task {
            if let item = await Item(link: url?.absoluteString, note: notetext) {
                modelContext.insert(item)
                try? modelContext.save()
                UpdateAll()
                extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            } else {
                alertPresented = true
            }
        }
    }
}

#Preview {
    ShareView(extensionContext: nil, url: URL(string: "apple.com"))
}
