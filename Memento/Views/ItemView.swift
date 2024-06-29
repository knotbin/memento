//
//  ItemView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/19/24.
//

import SwiftUI
import LinkPresentation
import UIKit

struct ItemView: View {
    @Environment(\.openURL) var openURL
    var item: Item 
    
    var body: some View {
        Button {
            item.viewed = true
            openURL(item.url)
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
                    Text(item.metadata?.title ?? item.link)
                        .bold()
                        .tint(Color.primary)
                        .lineLimit(1)
                    if let note = item.note {
                        Text(note)
                            .multilineTextAlignment(.leading)
                            .tint(.secondary)
                    }
                }
                Spacer()
                Image(systemName: item.viewed ? "book.fill" : "book")
            }
        }
    }
}

