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
            Form {
                Link("App Settings", destination: URL(string: UIApplication.openSettingsURLString)!)
                BugReporterView()
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
