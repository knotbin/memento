//
//  SettingsView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 7/15/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("widgetDirectToLink") var widgetDirectToLink: Bool = true
    @AppStorage("autoViewedOnOpen") var autoViewedOnOpen: viewedTypes = .notes
    @AppStorage("openLinkAutoViewed") var openLinkAutoViewed: Bool = true
    @Binding var isShown: Bool
    var body: some View {
        NavigationStack {
            Form {
                Toggle("Widget Opens Links Directly", isOn: $widgetDirectToLink)
                
                Section("Marking Viewed") {
                    Picker("Mark Viewed When Detail View is opened", selection: $autoViewedOnOpen) {
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
                    Toggle("Mark opened links viewed", isOn: $openLinkAutoViewed)
                    
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
