//
//  AddItemView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var linkText = ""
    @Binding var shown: Bool
    
    var body: some View {
        Form {
            TextField("Enter URL", text: $linkText)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            Button {
                addItem(link: linkText)
                shown = false
            } label: {
                Text("Add Link")
            }
        }
    }
    
    func addItem(link: String) {
        var url = link
        if link.hasPrefix("https://www.") || link.hasPrefix("http://www.") {
            url = link
        } else {
            url = "https://www.\(link)"
        }
        let item = Item(timestamp: Date(), link: url)
        modelContext.insert(item)
    }
}

#Preview {
    AddItemView(shown: .constant(false))
        .modelContainer(for: Item.self, inMemory: true)
}
