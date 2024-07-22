//
//  InfoView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 7/15/24.
//

import SwiftUI
import BugReporter

struct InfoView: View {
    @Binding var isShown: Bool
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    var body: some View {
        NavigationStack {
            BugReporterView(isShown: $isShown)
            Form {
                Link( destination: URL(string: UIApplication.openSettingsURLString)!, label: {Label("Memento Settings", systemImage: "gear")})
                
                Section("Socials") {
                    Link(destination: URL(string: "https://www.x.com/_mementoapp")!, label: {Label("Memento on Twitter", systemImage: "bubble")})
                    Link(destination: URL(string: "https://www.x.com/_mementoapp")!, label: {Label("Memento on Github", systemImage: "applescript")})
                    Link(destination: URL(string: "https://www.x.com/knotbin")!, label: {Label("Roscoe on Twitter", systemImage: "person.bubble")})
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        isShown = false
                    }
                }
            }
            .navigationTitle("Memento")
        }
    }
}

#Preview {
    InfoView(isShown: .constant(true))
}
