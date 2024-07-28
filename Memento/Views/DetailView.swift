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
    @Environment(\.modelContext) var modelContext
    
    @Environment(\.openURL) var openURL
    
    @AppStorage("linkOpenViewed") var linkOpenViewed: Bool?
    @AppStorage("autoViewedOnOpen") var autoViewedOnOpen: String?
    
    var item: Item
    @Binding var selectedItem: Item?
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Created \(item.timestamp.formatted())")
                    .font(.caption2)
                    .padding(.top, 10)
                    .textCase(.uppercase)
                VStack(alignment: .leading) {
                    if item.link != nil {
                        Button {
                            if linkOpenViewed == Optional(true) {
                                item.viewed = true
                            }
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
                        .buttonStyle(.borderless)
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
                        
                        if let url = item.url {
                            ShareLink(item: url) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        } else if let note = item.note, !note.isEmpty {
                            ShareLink(item: note) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        }
                        
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
                markViewedOnOpen()
            }
        }
    }
    func markViewedOnOpen() {
        switch autoViewedOnOpen {
        case "all":
            item.viewed = true
        case "onlyNotes" where item.link == nil && item.note != nil:
            item.viewed = true
        case "onlyLinks" where item.link != nil && item.note == nil:
            item.viewed = true
        case "containsNotes" where item.note != nil:
            item.viewed = true
        case "containsLinks" where item.link != nil:
            item.viewed = true
        default:
            break
        }
    }
}
