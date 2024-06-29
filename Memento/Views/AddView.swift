//
//  AddView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData
import LinkPresentation
import WidgetKit

struct AddView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var viewModel = AddViewModel()
    @Binding var shown: Bool
    
    let provider = LPMetadataProvider()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter URL", text: $viewModel.itemText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                Section {
                    TextField("Add Notes (optional)", text: $viewModel.noteText, axis: .vertical)
                        .lineLimit(5...10)
                }
            }
            .navigationTitle("New Item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        shown = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            if viewModel.noteText.isEmpty {
                                await addItem(link: viewModel.itemText)
                            } else {
                                await addItem(link: viewModel.itemText, note: viewModel.noteText)
                            }
                            
                        }
                        shown = false
                    }
                    .disabled(viewModel.itemText.isEmpty)
                    .keyboardShortcut(.defaultAction)
                    
                }
                
            }
        }
    }
    
    func addItem(link: String, note: String? = nil) async {
        guard let item = await Item(link: link, note: note) else {
            return
        }
        modelContext.insert(item)
        MementoShortcuts.updateAppShortcutParameters()
        WidgetCenter.shared.reloadAllTimelines()
    }
}

#Preview {
    AddView(shown: .constant(false))
        .modelContainer(for: Item.self, inMemory: true)
}
