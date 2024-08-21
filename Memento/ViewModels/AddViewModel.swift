//
//  AddViewModel.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/26/24.
//

import Foundation
import SwiftUI

@Observable
class AddViewModel {
    var linkText = ""
    var noteText = ""
    var saving: Bool = false
    var exiting: Bool = false
    
    init() {}
}
