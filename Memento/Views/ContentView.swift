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
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationSplitView {
            ZStack {
                ListView(selectedItem: $viewModel.selectedItem)
                    .modelContext(modelContext)
                VStack {
                    Spacer()
                    Button {
                        viewModel.sheetShown = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.large)
                            .padding(.top, 11)
                            .padding(.bottom, 15)
                            .padding(.horizontal, 15)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle)
                    .shadow(radius: 10)
                }
            }
            .sheet(isPresented: $viewModel.sheetShown, content: {
                AddView(shown: $viewModel.sheetShown)
            })
            .sheet(isPresented: $viewModel.infoShown, content: {
                InfoView(isShown: $viewModel.infoShown)
            })
#if !targetEnvironment(macCatalyst)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Info", systemImage: "info.circle", action: {viewModel.infoShown = true})
                }
            }
#endif
        } detail: {
            VStack {
                if let selectedItem = viewModel.selectedItem {
                    DetailView(item: selectedItem, selectedItem: $viewModel.selectedItem)
                } else {
                    Text("No Items selected")
                }
            }
#if targetEnvironment(macCatalyst)
            .toolbar { ToolbarItem(placement: .topBarTrailing) {
                Button("New Item", systemImage: "square.and.pencil", action: {viewModel.sheetShown = true})
            } }
#endif
        }
    }
}

#Preview {
    ContentView()
}
