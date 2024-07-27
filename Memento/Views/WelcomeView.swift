//
//  WelcomeView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 7/27/24.
//

import SwiftUI

enum Tab {
    case first
    case second
    case third
    case fourth
    case fifth
}

struct WelcomeView: View {
    @Binding var shown: Bool
    @State var selectedTab: Tab = .first
    
    var body: some View {
        TabView(selection: $selectedTab) {
            VStack {
                Image("Icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                Text("Welcome to Memento!")
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                Text("Memento is your personal inbox, helping you remember the things you save.")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                Button {
                    withAnimation {
                        selectedTab = .second
                    }
                } label: {
                    HStack {
                        Text("Next")
                        Image(systemName: "arrow.right")
                    }
                }
                .buttonStyle(.borderedProminent)
                .sensoryFeedback(.selection, trigger: selectedTab)
            }
            .padding()
            .tag(Tab.first)
            VStack {
                Image(systemName: "square.and.arrow.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .foregroundStyle(.white)
                    .padding()
                Text("Easily Save Items")
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                Text("Save links to Memento quickly using the share sheet and save notes easily using Siri or the action button.")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                Button {
                    withAnimation {
                        selectedTab = .third
                    }
                } label: {
                    HStack {
                        Text("Next")
                        Image(systemName: "arrow.right")
                    }
                }
                .buttonStyle(.borderedProminent)
                .sensoryFeedback(.selection, trigger: selectedTab)
            }
            .padding()
            .tag(Tab.second)
            VStack {
                Image(systemName: "square.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .foregroundStyle(.white)
                    .padding()
                Text("Add a widget")
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                Text("Add the Memento widget to your home screen or lock screen so it can remind you of these ideas.")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                Button {
                    withAnimation {
                        selectedTab = .fourth
                    }
                } label: {
                    HStack {
                        Text("Next")
                        Image(systemName: "arrow.right")
                    }
                }
                .buttonStyle(.borderedProminent)
                .sensoryFeedback(.selection, trigger: selectedTab)
            }
            .padding()
            .tag(Tab.third)
            VStack {
                Image(systemName: "doc.text.viewfinder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .foregroundStyle(.white)
                    .padding()
                Text("Revisit your ideas")
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                Text("The widget will show you a different random unviewed item each hour to remind you of them in an unintrusive way.")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                Button {
                    withAnimation {
                        shown = false
                    }
                } label: {
                    Label("Done", systemImage: "checkmark.circle")
                }
                .buttonStyle(.borderedProminent)
                .sensoryFeedback(.selection, trigger: selectedTab)
            }
            .padding()
            .tag(Tab.fourth)
        }
        .tabViewStyle(.page)
        .ignoresSafeArea(.all)
        .background(Gradient(colors: [Color.init(red: 0, green: 0.72, blue: 1), Color.init(red: 0.02, green: 0.53, blue: 0.74)]))
    }
}

#Preview {
    WelcomeView(shown: .constant(true))
}
