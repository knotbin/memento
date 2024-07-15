//
//  DetailView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 7/8/24.
//

import SwiftUI
import UIKit
import SwiftData

struct DetailView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.modelContext) var modelContext
    @Environment(\.openURL) var openURL
    var item: Item
    @Binding var selectedItem: Item?
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Created \(item.timestamp.formatted())").font(.caption2)
                VStack(alignment: .leading) {
                    if item.link != nil {
                        Button {
                            item.viewed = true
                            if let url = item.url {
                                openURL(url)
                            }
                        } label: {
                            GroupBox(label: Label("Link", systemImage: "link").foregroundStyle(Color.primary)) {
                                HStack(alignment: .top) {
                                    if let data = item.metadata?.siteImage, let image = UIImage(data: data) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: 100)
                                            .cornerRadius(10)
                                            .shadow(radius: 2)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(item.metadata?.title ?? "")
                                            .font(.headline).bold()
                                            .tint(Color.primary)
                                        Text(item.link?.replacingOccurrences(of: "https://", with: "") ?? "")
                                            .lineLimit(2)
                                    }
                                    .multilineTextAlignment(.leading)
                                }
                            }
                        }
                        .padding()
                    }
                    Text(item.note ?? "")
                        .multilineTextAlignment(.leading)
                        .tint(.secondary)
                        .font(.system(size: 20))
                        .padding()
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(item.viewed ? "Unmark Viewed" : "Mark Viewed", systemImage: item.viewed ? "book.fill" : "book") {
                            withAnimation {
                                item.viewed.toggle()
                                UpdateAll()
                            }
                        }
                        .buttonStyle(.bordered)
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            withAnimation {
                                modelContext.delete(item)
                                UpdateAll()
                                selectedItem = nil
                            }
                        }
                    } label: {
                        Label("Actions", systemImage: "ellipsis.circle")
                    }
                }
            }
            .navigationTitle(item.metadata?.title ?? item.note ?? "Item")
            .navigationBarTitleDisplayMode(.inline)
            
            .onAppear {
                if item.link == nil && item.note != nil {
                    item.viewed = true
                }
            }
        }
    }
}
