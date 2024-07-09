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
    var item: Item
    
    var body: some View {
        HStack {
            if !item.viewed {
                Image(systemName: "circle.fill")
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
                        Text(item.metadata?.title ?? item.link ?? "")
                            .bold()
                            .tint(Color.primary)
                            .lineLimit(1)
                        Text(item.note ?? "")
                            .multilineTextAlignment(.leading)
                            .tint(.secondary)
                    }
                }
            }
        }
        .contextMenu(
            ContextMenu(
                menuItems: {
                    Button(
                        "Delete",
                        systemImage: "trash",
                        role: .destructive,
                        intent: DeleteItemIntent(item: item)
                    )
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
            Button(
                "Delete",
                systemImage: "trash",
                role: .destructive,
                intent: DeleteItemIntent(item: item)
            )
        }
    }
}

