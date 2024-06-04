//
//  Paste.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/4/24.
//

import Foundation
import SwiftUI

public func paste() -> String? {
    let pasteboard = UIPasteboard.general
    
    let pastetext = pasteboard.string
    
    return pastetext
}
