//
//  LinkFromPaste.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/26/24.
//

import Foundation

func LinkFromPaste() async -> Link? {
    let pasteText = paste()
    guard let address: String = pasteText else {
        return nil
    }
    guard let link = await makeLink(address: address) else {
        return nil
    }
    return link
}
