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
    var selecteditem: Item?
    var body: some View {
        if let item = selecteditem {
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
                                Button(item.viewed ? "Unmark Viewed" : "Mark Viewed", systemImage: "book") {
                                    item.viewed.toggle()
                                }
                                Button("Delete", systemImage: "trash") {
                                    modelContext.delete(item)
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
                    }
                    .padding()
                }
                Text(item.note ?? "")
                    .multilineTextAlignment(.leading)
                    .tint(.secondary)
                    .font(.system(size: 20))
            }
            .padding()
        } else {
            Text("No item selected")
        }
    }
}

#Preview {
    DetailView()
}
