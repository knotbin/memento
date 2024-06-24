//
//  NoteView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/24/24.
//

import SwiftUI

struct NoteView: View {
    var note: Note
    var body: some View {
        NavigationLink {
            ScrollView {
                Text(note.text)
                    .font(.system(size: 30))
                    .multilineTextAlignment(.leading)
                    .navigationTitle("Note")
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
            }
        } label: {
            HStack(alignment: .top) {
                Text(note.text)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing)
                    .tint(.primary)
                Spacer()
                Image(systemName: note.viewed ? "book.fill" : "book")
            }
        }
    }
}

#Preview {
    NavigationStack {
        NoteView(note: Note("The desision to fade to black in the season five series finale of the hit drama 'Lost' was a tasteful creative choice."))
            .frame(maxHeight: 50)
    }
}
