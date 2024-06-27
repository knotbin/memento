//
//  LinkView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/19/24.
//

import SwiftUI
import LinkPresentation
import UIKit

struct LinkView: View {
    @Environment(\.openURL) var openURL
    var link: Link 
    
    var body: some View {
        Button {
            link.viewed = true
            openURL(link.url)
        } label: {
            HStack(alignment: .top) {
                if let data = link.metadata?.siteImage, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .frame(width: 70, height: 50)
                        .shadow(radius: 2)
                } else {
                    Image("EmptyLink")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .frame(width: 70, height: 50)
                        .shadow(radius: 2)
                }
                VStack {
                    Text(link.metadata?.title ?? link.address)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.primary)
                }
                Spacer()
                Image(systemName: link.viewed ? "book.fill" : "book")
            }
            .frame(maxHeight: 70)
        }
    }
}

#Preview {
    struct AsyncTestView: View {
        
        @State var passedValue = LPLinkMetadata()
        
        var body: some View {
            LinkView(link: Link(address: "https://chess.com", url: URL(string: "https://chess.com")!, metadata: CodableLinkMetadata(metadata: passedValue)))
                .task {
                    passedValue = await fetchMetadata(url: URL(string: "https://chess.com")!)
                }
        }
    }
    
    return AsyncTestView()
}
