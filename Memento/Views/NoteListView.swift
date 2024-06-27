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
    
    var body: some View {
        List(notes) { note in
            NoteView(note: note)
        }
    }
}

#Preview {
    NoteListView()
}
