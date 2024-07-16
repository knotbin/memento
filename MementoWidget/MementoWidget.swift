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
}

struct MementoWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    @Query(
        FetchDescriptor<Item>(predicate: #Predicate {$0.viewed == false}),
        animation: .snappy
    ) var items: [Item]


    
    var body: some View {
        if let item = items.randomElement() {
            let widgetURL = URL(string: "memento://item/\(item.id)")
            switch family {
            case .accessoryInline:
                VStack {
                    if item.link != nil {
                        Text(item.metadata?.title ?? item.link ?? "")
                    } else {
                        Text(item.note ?? "")
                    }
                }
                .widgetURL(widgetURL)
            case .accessoryRectangular:
                VStack(alignment: .leading) {
                    Text("MEMENTO")
                        .font(.caption).bold()
                    if item.link != nil {
                        Text(item.metadata?.title ?? item.link ?? "")
                            .bold()
                    }
                    if item.note != nil {
                        Text(item.note ?? "")
                    }
                }
                .widgetURL(widgetURL)
            case .systemSmall:
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        if let data = item.metadata?.siteImage, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }
                        if item.link != nil {
                            Text(item.metadata?.title ?? item.link ?? "")
                        }
                    }
                    Text(item.note ?? "")
                        .font(.subheadline)
                    HStack {
                        Button(intent: ItemViewedIntent(item: item), label: {
                            Image(systemName: "book")
                        })
                            .clipShape(Circle())
                        Button(intent: DeleteItemIntent(item: item), label: {Image(systemName: "trash")})
                            .clipShape(Circle())
                    }
                }
                .transition(.push(from: .bottom))
                .widgetURL(widgetURL)
            case .systemMedium:
                HStack {
                    VStack(alignment: .leading) {
                        if let data = item.metadata?.siteImage, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }
                        if item.link != nil {
                            Text(item.metadata?.title ?? item.link ?? "")
                                .bold()
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.primary)
                                .lineLimit(2)
                        }
                    }
                    VStack(alignment: .leading) {
                        if let note = item.note, note.count >= 30 {
                            Text(note)
                            HStack {
                                Button(
                                    intent: ItemViewedIntent(item: item),
                                    label: {
                                        Label(
                                            "Viewed",
                                            systemImage: "book"
                                        ).labelStyle(.iconOnly)
                                })
                                Button(
                                    intent: DeleteItemIntent(item: item),
                                    label: {
                                        Label(
                                            "Delete",
                                            systemImage: "trash"
                                        ).labelStyle(.iconOnly)
                                })
                            }
                        } else {
                            Text(item.note ?? "")
                                .font(.subheadline)
                            Button(
                                intent: ItemViewedIntent(item: item),
                                label: {
                                    Label(
                                        "Viewed",
                                        systemImage: "book"
                                    ).frame(maxWidth: .infinity)
                            })
                            Button(
                                intent: DeleteItemIntent(item: item),
                                label: {
                                    Label(
                                        "Delete",
                                        systemImage: "trash"
                                    ).frame(maxWidth: .infinity)
                            })
                        }
                    }
                }
                .transition(.push(from: .bottom))
                .widgetURL(widgetURL)
            default:
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        if let data = item.metadata?.siteImage, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }
                        if item.link != nil {
                            Text(item.metadata?.title ?? item.link ?? "")
                                .bold()
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.primary)
                        }
                    }
                    Text(item.note ?? "")
                        .font(.subheadline)
                    HStack {
                        Button(intent: ItemViewedIntent(item: item), label: {
                            Image(systemName: "book")
                        })
                            .clipShape(Circle())
                        Button(intent: DeleteItemIntent(item: item), label: {Image(systemName: "trash")})
                            .clipShape(Circle())
                    }
                }
                .transition(.push(from: .bottom))
                .widgetURL(widgetURL)
            }
        } else {
            Text("There are no unviewed items.")
                .multilineTextAlignment(.center)
                .widgetURL(nil)
        }
        
    }
}

struct MementoWidget: Widget {
    let modelContainer = ConfigureModelContainer()
    let kind: String = "MementoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MementoWidgetEntryView(entry: entry)
                .modelContainer(modelContainer)
                .containerBackground(.fill.tertiary, for: .widget)
        }
#if os(watchOS)
        .supportedFamilies([.accessoryRectangular])
#else
        .supportedFamilies([.accessoryRectangular, .accessoryInline, .systemSmall, .systemMedium])
#endif
    }
}

#Preview(as: .accessoryRectangular) {
    MementoWidget()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}
