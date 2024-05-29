//
//  URLPreviewView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/27/24.
//

import SwiftUI
import LinkPresentation

struct URLPreview : UIViewRepresentable {
    var url: URL

    func makeUIView(context: Context) -> LPLinkView {
        let view = LPLinkView(url: url)
        
        let provider = LPMetadataProvider()

        provider.startFetchingMetadata(for: url) { (metadata, error) in
            if let md = metadata {
                DispatchQueue.main.async {
                    view.metadata = md
                    view.sizeToFit()
                }
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: LPLinkView, context: UIViewRepresentableContext<URLPreview>) {}
}
