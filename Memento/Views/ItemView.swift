//
//  ItemView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/19/24.
//

import SwiftUI
import UIKit
import SwiftData

struct ItemView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.modelContext) var modelContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var item: Item
    @Binding var selectedItem: Item?
    
    @State private var editShown: Bool = false
    
    // Store the rotation and torn edges states
    @State private var rotation: Int = Int.random(in: -3...3)

    var isSelected: Bool {
        return selectedItem == item
    }
    
    var body: some View {
        VStack {
            if let url = item.url {
                Button {
                    item.viewed = true
                    openURL(url)
                } label: {
                    VStack(alignment: .leading) {
                        if let data = item.metadata?.siteImage, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        VStack(alignment: .leading) {
                            if item.link != nil {
                                Text(item.metadata?.title ?? item.link ?? "")
                                    .bold()
                                    .tint(Color.primary)
                                    .lineLimit(1)
                            }
                            Text(item.note ?? "")
                                .multilineTextAlignment(.leading)
                                .tint(.secondary)
                                .lineLimit(2)
                        }
                    }
                    .padding(10)
                }
                .background(Color.init(.systemGray6))
                .cornerRadius(0)
                .shadow(radius: 5)
            } else if let note = item.note {
                let baseHeight: CGFloat = 75 // Base height for up to 15 characters
                let extraHeightPerCharacter: CGFloat = 2 // Additional height per character after 15
                let characterCount = note.count
                let dynamicHeight = baseHeight + CGFloat(max(0, characterCount)) * extraHeightPerCharacter

                if horizontalSizeClass == .compact {
                    Text(note)
                        .padding()
                        .frame(width: 150, height: dynamicHeight)
                        .background(
                            TornRectangle(tornEdges: .vertical) // Use stored tornEdges state
                                .fill(Color.init(.systemGray6))
                                .frame(width: 150, height: dynamicHeight)
                                .shadow(radius: 5)
                        )
                } else if horizontalSizeClass == .regular {
                    Text(note)
                        .padding()
                        .frame(width: 250, height: dynamicHeight * 0.7)
                        .background(
                            TornRectangle(tornEdges: .vertical) // Use stored tornEdges state
                                .fill(Color.init(.systemGray6))
                                .frame(width: 250, height: dynamicHeight * 0.7)
                                .shadow(radius: 5)
                        )
                }
            }
        }
        .padding(10)
        .contextMenu(
            ContextMenu(
                menuItems: {
                    Button(
                        item.viewed ? "Unmark Viewed": "Mark Viewed",
                        systemImage: "book",
                        action: {
                            withAnimation {
                                item.viewed.toggle()
                            }
                            UpdateAll()
                        }
                    )
                    
                    if let url = item.url {
                        ShareLink(item: url) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    } else if let note = item.note, !note.isEmpty {
                        ShareLink(item: note) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                    Button("Edit", systemImage: "pencil") {
                        withAnimation {
                            editShown = true
                        }
                    }
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        Task {
                            try await Task.sleep(for: .seconds(1))
                            withAnimation {
                                selectedItem = nil
                                modelContext.delete(item)
                                UpdateAll()
                            }
                        }
                    }
            })
        )
        .rotationEffect(.degrees(Double(rotation)))
        .swipeActions(edge: .leading) {
            if let url = item.url {
                Button(
                    "Open",
                    systemImage: "arrow.uturn.right",
                    action: {
                        withAnimation {
                            item.viewed = true
                            UpdateAll()
                        }
                        openURL(url)
                    }
                ).tint(.accentColor)
            }
            Button(
                { item.viewed ? "Unmark Viewed" : "Mark Viewed" }(),
                systemImage: "book",
                action: {
                    withAnimation {
                        item.viewed.toggle()
                    }
                    UpdateAll()
                }
            ).tint(.indigo)
        }
        .swipeActions(edge: .trailing) {
            Button("Delete", systemImage: "trash", role: .destructive) {
                withAnimation {
                    selectedItem = nil
                    modelContext.delete(item)
                    UpdateAll()
                }
            }
            Button("Edit", systemImage: "pencil") {
                withAnimation {
                    editShown = true
                }
            }
            .tint(.orange)
        }
        .sheet(isPresented: $editShown, content: {
            EditView(shown: $editShown, item: item)
        })
    }
}
