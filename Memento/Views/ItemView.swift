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
                } else {
                    Image("EmptyItem")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .frame(width: 70, height: 50)
                        .shadow(radius: 2)
                }
                VStack {
                    Text(item.metadata?.title ?? item.link)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.primary)
                }
                Spacer()
                Image(systemName: item.viewed ? "book.fill" : "book")
            }
            .frame(maxHeight: 70)
        }
    }
}

#Preview {
    struct AsyncTestView: View {
        
        @State var passedValue = LPLinkMetadata()
        
        var body: some View {
            ItemView(item: Item(link: "https://chess.com", url: URL(string: "https://chess.com")!, metadata: CodableLinkMetadata(metadata: passedValue)))
                .task {
                    passedValue = await fetchMetadata(url: URL(string: "https://chess.com")!)
                }
        }
    }
    
    return AsyncTestView()
}
