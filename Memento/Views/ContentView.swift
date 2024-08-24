//
//  ContentView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/28/24.
//

import SwiftUI
import SwiftData
import CoreHaptics

struct ContentView: View {
    @AppStorage("welcomeOpen") var welcomeOpen = true
    @AppStorage("reviewRequested") var reviewRequested: Bool = false
    @State var viewModel = ContentViewModel()
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.requestReview) var requestReview
    
    @Query var items: [Item]
    
    var body: some View {
        NavigationSplitView {
            ZStack(alignment: .bottomTrailing) {
                ListView(selectedItem: $viewModel.selectedItem)
                    .modelContext(modelContext)
                Button {
                    viewModel.addingItem.toggle()
                    viewModel.sheetShown = true
                } label: {
                    Image(systemName: "pencil")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding()
            }
            .task {
                if items.count >= 4 && !reviewRequested {
                    try? await Task.sleep(for: .seconds(5))
                    requestReview()
                    reviewRequested = true
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
                        .sensoryFeedback(.selection, trigger: viewModel.infoShown)
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
        .fullScreenCover(isPresented: $welcomeOpen, content: {WelcomeView(shown: $welcomeOpen)})
    }
}

#Preview {
    ContentView()
}
