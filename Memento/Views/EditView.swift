//
//  AddView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData
import LinkPresentation

struct EditView: View {
    enum FocusableField: Hashable, CaseIterable {
        case link, note
    }
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State var viewModel = AddViewModel()
    @Binding var shown: Bool
    
    var item: Item
    
    @FocusState var focus: FocusableField?
    
    let provider = LPMetadataProvider()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField("Enter URL", text: $viewModel.linkText)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .focused($focus, equals: .link)
                    .padding(.bottom)
                Text("Notes")
                    .font(.headline)
                TextEditor(text: $viewModel.noteText)
                    .focused($focus, equals: .note)
                
            }
            .padding()
            .navigationTitle("New Item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        viewModel.exiting = true
                        shown = false
                    }
                    .sensoryFeedback(.stop, trigger: viewModel.exiting)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.saving = true
                        Task {
                            await addLink()
                            UpdateAll()
                        }
                        shown = false
                    }
                    .sensoryFeedback(.success, trigger: viewModel.saving)
                    .disabled(viewModel.linkText.isEmpty && viewModel.noteText.isEmpty)
                    .keyboardShortcut(.defaultAction)
                    
                }
                
            }
        }
        .onAppear {
            focus = EditView.FocusableField.allCases.first
            viewModel.linkText = item.link ?? ""
            viewModel.noteText = item.note ?? ""
        }
    }
    
    func addLink() async {
        if item.link != viewModel.linkText {
            item.link = viewModel.linkText
            item.url = URL(string: viewModel.linkText)
            if item.url != nil {
                item.metadata = await CodableLinkMetadata(metadata: fetchMetadata(url: item.url!))
            }
        }
        item.note = viewModel.noteText
        try? modelContext.save()
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
                await addLink()
                UpdateAll()
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
