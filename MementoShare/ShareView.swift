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
    
    @State var notetext = ""
    @State var alertPresented = false
    @FocusState var focus
    
    let extensionContext: NSExtensionContext?
    let url: URL
    let linkprovider = LPMetadataProvider()
    
    var body: some View {
        NavigationStack {
            Form {
                Text(url.absoluteString)
                    .lineLimit(1)
                TextField("Notes (optional)", text: $notetext, axis: .vertical)
                    .lineLimit(5...10)
                    .focused($focus)
                    .onAppear { focus = true }
            }
            .onSubmit {
                Task {
                    if let item = await Item(link: url.absoluteString, note: notetext) {
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
                            if let item = await Item(link: url.absoluteString, note: notetext) {
                                modelContext.insert(item)
                            } else {
                                alertPresented = true
                            }
                            UpdateAll()
                            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                        }
                    }
                }
            }
            .navigationTitle("New Item")
            .toolbarTitleDisplayMode(.inline)
        }
        .alert(isPresented: $alertPresented) {
            Alert(title: Text("An error occured"))
        }
    }
    
}

#Preview {
    ShareView(extensionContext: nil, url: URL(string: "apple.com")!)
}
