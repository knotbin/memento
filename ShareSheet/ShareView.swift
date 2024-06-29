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
                            Task {
                                let item = await Item(link: url.absoluteString)
                                guard let fullitem = item else {
                                    extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                                    return
                                }
                                modelContext.insert(fullitem)
                                UpdateAll()
                                extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                            }
                        }
                    }
                }
            }
    }
    
}

#Preview {
    ShareView()
}
