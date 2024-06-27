//
//  NoteListView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/25/24.
//

import SwiftUI
import SwiftData

struct NoteListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.timestamp, order: .reverse, animation: .smooth) private var notes: [Note]
    
    @State var viewModel = NoteListViewModel()
    
    var body: some View {
        NavigationStack {
            List(notes) { note in
                NoteView(note: note)
            }
            .navigationTitle("Notes")
            .overlay {
                if notes.isEmpty {
                    ContentUnavailableView("No Notes Added", systemImage: "note")
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Add Note", systemImage: "plus") {
                        viewModel.sheetshown = true
                    }
                }
            }
            .sheet(isPresented: $viewModel.sheetshown) {
                AddNoteView(shown: $viewModel.sheetshown)
            }
        }
    }
}

#Preview {
    NoteListView()
}
