//
//  ItemView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/1/24.
//

import SwiftUI
import LinkPresentation

struct ItemView: View {
    var item: Item
    
    var body: some View {
        VStack {
            if let data = item.metadata.siteImage, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .cornerRadius(10)
                    .padding(10)
            } else {
                Image("EmptyLink")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .cornerRadius(10)
                    .padding(10)
            }
            VStack {
                Text(item.metadata.title ?? item.link)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            .padding(10)
        }
        .background(Color.gray.opacity(0.3))
        .cornerRadius(20)
        .frame(width: 180, height: 190)
    }
}

#Preview {
    struct AsyncTestView: View {
        
        @State var passedValue = LPLinkMetadata()
        
        var body: some View {
            ItemView(item: Item(link: "https://x.com/itswords_/status/1796776745112072330/photo/1", url: URL(string: "https://x.com/itswords_/status/1796776745112072330/photo/1")!, metadata: CodableLinkMetadata(metadata: passedValue)))
                .task {
                    passedValue = await fetchMetadata(url: URL(string: "https://x.com/itswords_/status/1796776745112072330/photo/1")!)
                }
        }
    }
    
    return AsyncTestView()
}
