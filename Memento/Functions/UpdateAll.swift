//
//  UpdateAll.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/27/24.
//

import Foundation
import WidgetKit

func UpdateAll() {
    MementoShortcuts.updateAppShortcutParameters()
    WidgetCenter.shared.reloadAllTimelines()
}
