//
//  ContentView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/28/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var viewModel = ContentViewModel()

    var body: some View {
        NavigationStack {
            ListView()
            .toolbar { Button("Add Item", systemImage: "plus", action: viewModel.addSheet) }
            .navigationTitle("Items")
            .sheet(isPresented: $viewModel.sheetShown, content: {
                AddView(shown: $viewModel.sheetShown)
            })
        }
    }
}

#Preview {
    ContentView()
}
