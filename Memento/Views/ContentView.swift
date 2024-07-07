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
    let modelContext = ModelContext(ConfigureModelContainer())

    var body: some View {
        TabView {
            NavigationStack {
                ListView()
                .toolbar { Button("Add Item", systemImage: "plus", action: viewModel.addSheet) }
                .navigationTitle("Links")
                .sheet(isPresented: $viewModel.sheetShown, content: {
                    AddView(shown: $viewModel.sheetShown)
                })
                .modelContext(modelContext)
            }
            .tabItem({Label("Links", systemImage: "link")})
            Text("Not links")
                .tabItem({Label("Items", systemImage: "rectangle")})
        }
    }
}

#Preview {
    ContentView()
}
