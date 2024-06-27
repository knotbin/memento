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
    @State var viewModel = NewLinkViewModel()
    @Binding var shown: Bool
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AddNoteView(shown: .constant(true))
}
