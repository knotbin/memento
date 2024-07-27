//
//  InfoView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 7/15/24.
//

import SwiftUI

struct InfoView: View {
    @Binding var isShown: Bool
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    var body: some View {
        NavigationStack {
            Form {
                Link( destination: URL(string: UIApplication.openSettingsURLString)!, label: {Label("Memento Settings", systemImage: "gear")})
                
                Section("Socials") {
                    Link(destination: URL(string: "https://memento.knotbin.xyz")!, label: {Label("Official Website", systemImage: "globe")})
                    Link(destination: URL(string: "https://www.x.com/_mementoapp")!, label: {Label("Memento on Twitter", systemImage: "bubble")})
                    Link(destination: URL(string: "https://www.x.com/_mementoapp")!, label: {Label("Memento on Github", systemImage: "applescript")})
                    Link(destination: URL(string: "https://www.x.com/knotbin")!, label: {Label("Roscoe on Twitter", systemImage: "person.bubble")})
                }
                Section("Feedback") {
                    Link(destination: URL(string: "https://fbogmeocs87.typeform.com/to/Pc2mZtmg")!, label: {Label("Report a bug", systemImage: "ant")})
                    Link(destination: URL(string: "https://fbogmeocs87.typeform.com/to/iREGTSlU")!, label: {Label("Request a feature", systemImage: "tray.and.arrow.down")})
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        isShown = false
                    }
                }
            }
            .navigationTitle("Memento v\(appVersion)").navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    InfoView(isShown: .constant(true))
}
