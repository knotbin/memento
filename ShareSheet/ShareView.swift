//
//  ShareView.swift
//  ShareSheet
//
//  Created by Roscoe Rubin-Rottenberg on 5/28/24.
//

import SwiftUI
import SwiftData
import LinkPresentation

struct ShareView: View {
    @Environment(\.modelContext) private var modelContext
    
    var extensionContext: NSExtensionContext?
    
    let linkprovider = LPMetadataProvider()
    
    var body: some View {
        Text("Adding Item...")
        
            .onAppear {
                guard
                    let input = (extensionContext?.inputItems.first as! NSExtensionItem).attachments else {
                    extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                    return
                }
                for provider in input {
                    provider.loadItem(forTypeIdentifier: "public.url") { data, _ in
                        if let url = data as? URL {
                            var mainmetadata = LPLinkMetadata()
                            
                            linkprovider.startFetchingMetadata(for: url) { (metadata, error) in
                                if let md = metadata {
                                    DispatchQueue.main.async {
                                        mainmetadata = md
                                    }
                                } else {
                                    return
                                }
                            }
                            let item = Item(timestamp: Date(), link: url.absoluteString, url: url, metadata: CodableLinkMetadata(metadata: mainmetadata))
                            modelContext.insert(item)
                            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                        }
                    }
                }
//                let item = Item(timestamp: Date(), link: url.absoluteString, url: url)
//                modelContext.insert(item)
//                extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
    }
    
}

#Preview {
    ShareView()
}
