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
    
    var isSelected: Bool {
        if selectedItem == item {
            return true
        }
        return false
    }
    
    var body: some View {
        HStack {
            if !item.viewed {
                if horizontalSizeClass == .regular {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(isSelected ? Color.white : Color.accentColor)
                } else if horizontalSizeClass == .compact {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(Color.accentColor)
                }
            }
            Button {
                item.viewed = true
                if let url = item.url {
                    openURL(url)
                }
            } label: {
                HStack(alignment: .top) {
                    if let data = item.metadata?.siteImage, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .frame(width: 70, height: 50)
                            .shadow(radius: 2)
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
            }
        }
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
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        withAnimation {
                            selectedItem = nil
                            modelContext.delete(item)
                            UpdateAll()
                        }
                    }
            })
        )
        .swipeActions(edge: .leading) {
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
        }
    }
}

