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
    
    @State var notetext: String = ""
    @State var linkText = ""
    @State var alertPresented = false
    @FocusState var focus
    
    let note: String?
    let extensionContext: NSExtensionContext?
    let url: URL?
    let linkprovider = LPMetadataProvider()
    
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
                Task {
                    if let item = await Item(link: (url?.absoluteString ?? nil), note: notetext) {
                        modelContext.insert(item)
                    } else {
                        alertPresented = true
                    }
                    UpdateAll()
                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            if let item = await Item(link: url?.absoluteString, note: notetext) {
                                modelContext.insert(item)
                                try modelContext.save()
                                UpdateAll()
                                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                            } else {
                                alertPresented = true
                            }
                        }
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
            Alert(title: Text("An error occured"))
        }
    }
    init(extensionContext: NSExtensionContext?, url: URL? = nil, note: String? = nil) {
        self.extensionContext = extensionContext
        self.url = url
        self.note = note ?? ""
    }
}

#Preview {
    ShareView(extensionContext: nil, url: URL(string: "apple.com"))
}
