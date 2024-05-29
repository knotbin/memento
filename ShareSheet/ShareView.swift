//
//  ShareView.swift
//  ShareSheet
//
//  Created by Roscoe Rubin-Rottenberg on 5/28/24.
//

import SwiftUI
import SwiftData

struct ShareView: View {
    @Environment(\.modelContext) private var modelContext
    
    var extensionContext: NSExtensionContext?
    
    var body: some View {
        Text("Adding Item...")
        
            .onAppear {
                guard
                    let input = (extensionContext?.inputItems.first as! NSExtensionItem).attachments else {
                    extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                    return
                }
                print(input)
                for provider in input {
                    provider.loadItem(forTypeIdentifier: "public.url") { data, _ in
                        if let url = data as? URL {
                            print(url)
                            let item = Item(timestamp: Date(), link: url.absoluteString, url: url)
                            modelContext.insert(item)
                            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                            print("added")
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
