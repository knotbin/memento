//
//  ItemFromPaste.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/26/24.
//

import Foundation

func ItemFromPaste() async -> Item? {
    let pasteText = paste()
    guard let address: String = pasteText else {
        return nil
    }
    guard let item = await makeItem(address: address) else {
        return nil
    }
    return item
}
