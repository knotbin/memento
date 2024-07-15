//
//  SettingsView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 7/15/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("usesCloud") var cloud: Bool = false
    @AppStorage("autoViewedOnOpen") var autoViewedOnOpen: viewedTypes = .notes
    @Binding var isShown: Bool
    var body: some View {
        NavigationStack {
            Form {
                Toggle("Sync Through iCloud", isOn: $cloud)
                Section("Auto-mark viewed") {
                    Picker("Mark Viewed When Opened in Detail", selection: $autoViewedOnOpen) {
                        Text("Only Items with Notes")
                            .tag(viewedTypes.notes)
                        Text("Only Items with Links")
                            .tag(viewedTypes.links)
                        Text("All Items")
                            .tag(viewedTypes.all)
                        Text("None")
                            .tag(viewedTypes.none)
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        isShown = false
                    }
                }
            }
        }
    }
    enum viewedTypes: String, CaseIterable {
        case notes
        case links
        case all
        case none
    }
}

#Preview {
    SettingsView(isShown: .constant(true))
}
