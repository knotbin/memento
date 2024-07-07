//
//  UpdateAll.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/27/24.
//

import Foundation
#if canImport(WidgetKit)
    import WidgetKit
#endif

func UpdateAll() {
#if os(iOS) || os(macOS)
    WidgetCenter.shared.reloadAllTimelines()
#endif
}
