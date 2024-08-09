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
                HStack {
                    Label("Memento", systemImage: "tray")
                    Spacer()
                    Text("v\(appVersion)")
                        .foregroundStyle(.secondary)
                }
                Link( destination: URL(string: UIApplication.openSettingsURLString)!, label: {Label("Memento Settings", systemImage: "gear")})
                
                Section("Socials") {
                    Link(destination: URL(string: "https://www.x.com/_mementoapp")!, label: {Label("Memento on Twitter", systemImage: "bubble")})
                    Link(destination: URL(string: "https://www.x.com/_mementoapp")!, label: {Label("Memento on Github", systemImage: "applescript")})
                    Link(destination: URL(string: "https://www.x.com/knotbin")!, label: {Label("Roscoe on Twitter", systemImage: "person.bubble")})
                }
                Section("Links") {
                    Link(destination: URL(string: "https://memento.knotbin.xyz")!, label: {Label("Official Website", systemImage: "globe")})
                    Link(destination: URL(string: "https://memento.knotbin.xyz/legal/privacy")!, label: {Label("Privacy Policy", systemImage: "hand.raised")})
                    Link(destination: URL(string: "https://memento.knotbin.xyz/support")!, label: {Label("Support", systemImage: "questionmark.circle")})
                }
                Section("Feedback") {
                    Link(destination: URL(string: "https://fbogmeocs87.typeform.com/to/Pc2mZtmg")!, label: {Label("Report a bug", systemImage: "ant")})
                    Link(destination: URL(string: "https://fbogmeocs87.typeform.com/to/iREGTSlU")!, label: {Label("Request a feature", systemImage: "tray.and.arrow.down")})
                    Link(destination: URL(string: "mailto:memento@knotbin.xyz")!, label: {Label("Contact", systemImage: "envelope")})
                }
                Section(header: Text("About"), footer: Text("Copyright © Roscoe Rubin-Rottenberg 2024")) {
                    Text("Memento was made by Roscoe Rubin-Rottenberg, a 14 year old aspiring iOS developer and 2024 Apple Swift Student Challenge winner. It is completely open-source for full transparency and user confidence. If you'd like to follow or contribute to Memento's development, you can check out our Github.")
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        isShown = false
                    }
                }
            }
            .navigationTitle("Info").navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    InfoView(isShown: .constant(true))
}
