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
                            await addItem(link: viewModel.itemText)
                        }
                        shown = false
                    }
                    .disabled(viewModel.itemText.isEmpty)
                    .keyboardShortcut(.defaultAction)
                    
                }
                
            }
        }
    }
    
    func addItem(link: String) async {
        guard let item = await Item(link: link) else {
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
