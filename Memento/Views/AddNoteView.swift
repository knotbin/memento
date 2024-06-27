//
//  AddNoteView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/26/24.
//

import SwiftUI
import SwiftData

struct AddNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var shown: Bool
    @State var viewModel = AddNoteViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter Note", text: $viewModel.noteText, axis: .vertical)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .lineLimit(5...10)
                    .keyboardType(.URL)
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        shown = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        modelContext.insert(Note(viewModel.noteText))
                        shown = false
                    }
                    .disabled(viewModel.noteText.isEmpty)
                    .keyboardShortcut(.defaultAction)
                    
                }
                
            }
        }
    }
}

#Preview {
    AddNoteView(shown: .constant(true))
        .modelContext(ModelContext(ConfigureModelContainer()))
}
