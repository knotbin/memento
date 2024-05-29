//
//  ShareViewController.swift
//  ShareSheet
//
//  Created by Roscoe Rubin-Rottenberg on 5/28/24.
//

import SwiftUI
import UIKit
import SwiftData

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let modelContainer = ConfigureModelContainer()
        
        let contentView = UIHostingController(rootView: ShareView(extensionContext: extensionContext).modelContainer(modelContainer))
        self.addChild(contentView)
        self.view.addSubview(contentView.view)
        
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint (equalTo: self.view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint (equalTo: self.view.rightAnchor).isActive = true
    }

}
