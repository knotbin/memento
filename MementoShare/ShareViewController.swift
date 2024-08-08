//
//  ShareViewController.swift
//  ShareSheet
//
//  Created by Roscoe Rubin-Rottenberg on 5/28/24.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let input = (extensionContext?.inputItems.first as! NSExtensionItem).attachments?.first else {
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        let textDataType = UTType.plainText.identifier
        let urlDataType = UTType.url.identifier
        if input.hasItemConformingToTypeIdentifier(urlDataType) {
            input.loadItem(forTypeIdentifier: urlDataType, options: nil) { (provided, error) in
                if let url = provided as? URL {
                    DispatchQueue.main.async {
                        let contentView = UIHostingController(rootView: ShareView(extensionContext: self.extensionContext, url: url).modelContext(ModelContext(ConfigureModelContainer())))
                        self.addChild(contentView)
                        self.view.addSubview(contentView.view)
                        contentView.view.translatesAutoresizingMaskIntoConstraints = false
                        contentView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                        contentView.view.bottomAnchor.constraint (equalTo: self.view.bottomAnchor).isActive = true
                        contentView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                        contentView.view.rightAnchor.constraint (equalTo: self.view.rightAnchor).isActive = true
                    }
                } else {
                    self.close()
                    return
                }
            }
        }
        if input.hasItemConformingToTypeIdentifier(textDataType) {
            input.loadItem(forTypeIdentifier: textDataType, options: nil) { (providedText, error) in
                if error != nil {
                    self.close()
                    return
                }
                if let text = providedText as? String {
                    DispatchQueue.main.async {
                        let contentView = UIHostingController(rootView: ShareView(extensionContext: self.extensionContext, note: text))
                        self.addChild(contentView)
                        self.view.addSubview(contentView.view)
                        contentView.view.translatesAutoresizingMaskIntoConstraints = false
                        contentView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                        contentView.view.bottomAnchor.constraint (equalTo: self.view.bottomAnchor).isActive = true
                        contentView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                        contentView.view.rightAnchor.constraint (equalTo: self.view.rightAnchor).isActive = true
                    }
                } else {
                    self.close()
                    return
                }
            }
            
        }
        
    }
    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
