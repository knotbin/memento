//
//  ItemFromPaste.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/26/24.
//

import Foundation

func ItemFromPaste() async -> Item? {
    let pasteText = paste()
    guard let link: String = pasteText else {
        return nil
    }
    guard let item = await Item(link: link) else {
        return nil
    }
    return item
}
