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
    var item: Item
    @Binding var selectedItem: Item?
    var body: some View {
        VStack(alignment: .leading) {
            if horizontalSizeClass == .regular {
                HStack {
                    GroupBox(label: Label("Link", systemImage: "link")) {
                        HStack {
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
                                    .font(.title).bold()
                                    .tint(Color.primary)
                                Text(item.link ?? "")
                            }
                        }
                    }
                    VStack {
                        GroupBox(label: Label("Created", systemImage: "calendar")) {
                            Text(item.timestamp.formatted())
                        }
                        GroupBox(label: Label("Actions", image: "pencil")) {
                            HStack {
                                Button(item.viewed ? "Unmark Viewed" : "Mark Viewed", systemImage: item.viewed ? "book.fill" : "book") {
                                    withAnimation {
                                        item.viewed.toggle()
                                        UpdateAll()
                                    }
                                }
                                .buttonStyle(.bordered)
                                Button("Delete", systemImage: "trash") {
                                    selectedItem = nil
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }
                .padding()
            } else if horizontalSizeClass == .compact {
                VStack {
                    GroupBox(label: Label("Link", systemImage: "link")) {
                        HStack {
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
                                    .font(.title).bold()
                                    .tint(Color.primary)
                                Text(item.link ?? "")
                            }
                        }
                    }
                    GroupBox(label: Label("Created", systemImage: "calendar")) {
                        Text(item.timestamp.formatted())
                    }
                    GroupBox(label: Label("Actions", image: "pencil")) {
                        HStack {
                            Button(item.viewed ? "Unmark Viewed" : "Mark Viewed", systemImage: item.viewed ? "book.fill" : "book") {
                                withAnimation {
                                    item.viewed.toggle()
                                    UpdateAll()
                                }
                            }
                            .buttonStyle(.bordered)
                            Button("Delete", systemImage: "trash") {
                                selectedItem = nil
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                .padding()
            }
            Text(item.note ?? "")
                .multilineTextAlignment(.leading)
                .tint(.secondary)
                .font(.system(size: 20))
        }
        .padding()
    }
}
