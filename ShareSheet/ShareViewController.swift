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
        
        contentView.view.frame.size = CGSize(width: 200, height: 100)
        contentView.view.center = CGPoint(x: self.view.frame.size.width  / 2,
                                          y: self.view.frame.size.height / 2)
//        contentView.view.layer.cornerRadius = CGFloat(10)
    }

}
