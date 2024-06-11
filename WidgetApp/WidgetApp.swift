//
//  WidgetApp.swift
//  WidgetApp
//
//  Created by Roscoe Rubin-Rottenberg on 6/9/24.
//

import WidgetKit
import SwiftUI
import SwiftData

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
}

struct WidgetAppEntryView : View {
    @Query private var items: [Item]
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if let item = items.randomElement() {
                Text(item.metadata?.title ?? item.link)
                .widgetURL(item.url)
            } else {
                Text("No Items added")
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    WidgetApp()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}
