//
//  WidgetApp.swift
//  WidgetApp
//
//  Created by Roscoe Rubin-Rottenberg on 6/9/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    var links: [Link]?
}

struct WidgetAppEntryView : View {
    static var linkdescriptor = FetchDescriptor<Link>(predicate: #Predicate {$0.viewed == false})
    @Query(linkdescriptor, animation: .snappy) var links: [Link]
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if let link = links.randomElement() {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        if let data = link.metadata?.siteImage, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        } else {
                            Image("EmptyLink")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }
                        Text(link.metadata?.title ?? link.address)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.primary)
                    }
                    HStack {
                        Button(intent: LinkViewedIntent(link: link), label: {
                            Image(systemName: "book")
                        })
                        Button(intent: DeleteLinkIntent(link: link), label: {Image(systemName: "xmark")})
                    }
                }
                .padding(5)
                .transition(.push(from: .bottom))
            } else if entry.links != nil {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Image("EmptyLink")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .frame(height: 65)
                            .shadow(radius: 2)
                        Text("Memento")
                            .bold()
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.primary)
                    }
                    HStack {
                        Button(action: {}, label: {
                            Image(systemName: "book")
                        })
                        Button(action: {}, label: {Image(systemName: "xmark")})
                    }
                }
            } else {
                Text("You have no unviewed links")
            }
            
        }
    }
}

struct WidgetApp: Widget {
    let modelContainer = ConfigureModelContainer()
    let kind: String = "WidgetApp"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetAppEntryView(entry: entry)
                .modelContainer(modelContainer)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Link Display")
        .description("Shows a random link you saved, updating every hour.")
    }
}

#Preview(as: .systemSmall) {
    WidgetApp()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}
