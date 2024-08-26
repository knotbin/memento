//
//  AddView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData
import LinkPresentation

struct AddView: View {
    enum FocusableField: Hashable, CaseIterable {
        case link, note
    }
    @Environment(\.modelContext) private var modelContext
    
    @State var viewModel = AddViewModel()
    @State var loading: Bool = false
    @State var exiting: Bool = false
    @Binding var shown: Bool
    
    
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
                        exiting = true
                        shown = false
                    }
                    .sensoryFeedback(.stop, trigger: exiting)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            await addLink()
                        }
                    }
                    .sensoryFeedback(.success, trigger: loading)
                    .disabled(viewModel.linkText.isEmpty && viewModel.noteText.isEmpty)
                    .disabled(loading)
                    .keyboardShortcut(.defaultAction)
                    
                }
                ToolbarItem(placement: .principal) {
                    if loading {
                        ProgressView()
                    }
                }
                
            }
        }
        .onAppear {
            focus = AddView.FocusableField.note
        }
    }
    
    func addLink() async {
        loading = true
        guard let item = await Item(link: viewModel.linkText, note: viewModel.noteText) else {return}
        modelContext.insert(item)
        UpdateAll()
        shown = false
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
