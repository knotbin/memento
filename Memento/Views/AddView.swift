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
    enum FocusableField: Hashable, CaseIterable {
        case link, note
    }
    @Environment(\.modelContext) private var modelContext
    
    @State var viewModel = AddViewModel()
    @Binding var shown: Bool
    
    @FocusState var focus: FocusableField?
    
    let provider = LPMetadataProvider()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter URL", text: $viewModel.itemText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .focused($focus, equals: .link)
                Section {
                    TextField("Add Notes (optional)", text: $viewModel.noteText, axis: .vertical)
                        .lineLimit(5...10)
                        .focused($focus, equals: .note)
                }
            }
            .onSubmit {
                focusNextField()
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
        .onAppear {
            focus = AddView.FocusableField.allCases.first
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
    
    private func focusFirstField() {
        focus = FocusableField.allCases.first
    }

    private func focusNextField() {
        switch focus {
        case .link:
            focus = .note
        case .note:
            Task {
                await addItem(link: viewModel.itemText, note: viewModel.noteText)
                shown = false
            }
        case nil:
            break
        }
    }
}

#Preview {
    AddView(shown: .constant(false))
        .modelContainer(for: Item.self, inMemory: true)
}
