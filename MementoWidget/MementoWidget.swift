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
    ) var unviewedItems: [Item]
    @Query(animation: .snappy) var viewedItems: [Item]


    
    var body: some View {
        if let item = getItem() {
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
                    if let data = item.metadata?.siteImage, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    if item.link != nil {
                        Text(item.metadata?.title ?? item.link ?? "")
                            .font(.subheadline)
                            .bold()
                    }
                    if let note = item.note {
                        if item.link == nil || item.link?.isEmpty == true {
                            Spacer()
                        }
                        HStack(alignment: .bottom) {
                            Text(note)
                                .font(.caption)
                            if item.link != nil, item.link?.isEmpty == false {
                                Spacer()
                                if item.viewed == false {
                                    Button(
                                        intent: ItemViewedIntent(item: item),
                                        label: {
                                            Label(
                                                "Viewed",
                                                systemImage: "book"
                                            )
                                            .font(.caption)
                                            .labelStyle(.iconOnly)
                                    })
                                    .buttonStyle(.plain)
                                    .foregroundStyle(Color.accentColor)
                                }
                                Button(
                                    intent: ReloadWidgetIntent(),
                                    label: {
                                        Label(
                                            "Reload",
                                            systemImage: "arrow.clockwise"
                                        )
                                        .font(.caption)
                                        .labelStyle(.iconOnly)
                                })
                                .buttonStyle(.plain)
                                .foregroundStyle(Color.accentColor)
                            }
                        }
                    }
                    if item.note == nil || item.link == nil || item.link?.isEmpty == true {
                        Spacer()
                        HStack {
                            Spacer()
                            if item.viewed == false {
                                Button(
                                    intent: ItemViewedIntent(item: item),
                                    label: {
                                        Label(
                                            "Viewed",
                                            systemImage: "book"
                                        )
                                        .font(.caption)
                                        .labelStyle(.iconOnly)
                                })
                                .buttonStyle(.plain)
                                .foregroundStyle(Color.accentColor)
                            }
                            Button(
                                intent: ReloadWidgetIntent(),
                                label: {
                                    Label(
                                        "Reload",
                                        systemImage: "arrow.clockwise"
                                    )
                                    .font(.caption)
                                    .labelStyle(.iconOnly)
                            })
                            .buttonStyle(.plain)
                            .foregroundStyle(Color.accentColor)
                        }
                    }
                }
                .transition(.push(from: .bottom))
                .widgetURL(widgetURL)
            case .systemMedium:
                HStack {
                    if let data = item.metadata?.siteImage, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(3)
                    }
                    VStack {
                        Spacer()
                        if item.metadata?.siteImage != nil {
                            VStack(alignment: .leading) {
                                if item.link != nil, item.link?.isEmpty == false {
                                    Text(item.metadata?.title ?? item.link ?? "")
                                        .font(.headline)
                                        .bold()
                                        .multilineTextAlignment(.leading)
                                }
                                if item.note != nil, item.note?.isEmpty == false {
                                    Text(item.note ?? "")
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        } else {
                            VStack(alignment: .center) {
                                if item.link != nil, item.link?.isEmpty == false {
                                    Text(item.metadata?.title ?? item.link ?? "")
                                        .font(.headline)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                }
                                if item.note != nil, item.note?.isEmpty == false {
                                    Text(item.note ?? "")
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            if item.viewed == false {
                                Button(
                                    intent: ItemViewedIntent(item: item),
                                    label: {
                                        Label(
                                            "Viewed",
                                            systemImage: "book"
                                        )
                                        .font(.caption)
                                        .labelStyle(.iconOnly)
                                })
                                .buttonStyle(.plain)
                                .foregroundStyle(Color.accentColor)
                            }
                            Button(
                                intent: ReloadWidgetIntent(),
                                label: {
                                    Label(
                                        "Reload",
                                        systemImage: "arrow.clockwise"
                                    )
                                    .font(.caption)
                                    .labelStyle(.iconOnly)
                            })
                            .buttonStyle(.plain)
                            .foregroundStyle(Color.accentColor)
                        }
                    }
                }
                .transition(.push(from: .bottom))
                .widgetURL(widgetURL)
            case .systemLarge:
                VStack(alignment: .leading) {
                    if let data = item.metadata?.siteImage, let image = UIImage(data: data) {
                        Spacer()
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                    }
                    if item.link != nil {
                        Text(item.metadata?.title ?? item.link ?? "")
                            .font(.subheadline)
                            .bold()
                    }
                    if let note = item.note {
                        if item.link == nil || item.link?.isEmpty == true {
                            Spacer()
                        }
                        HStack(alignment: .bottom) {
                            Text(note)
                                .font(.caption)
                            if item.link != nil, item.link?.isEmpty == false {
                                Spacer()
                                if item.viewed == false {
                                    Button(
                                        intent: ItemViewedIntent(item: item),
                                        label: {
                                            Label(
                                                "Viewed",
                                                systemImage: "book"
                                            )
                                            .font(.caption)
                                            .labelStyle(.iconOnly)
                                    })
                                    .buttonStyle(.plain)
                                    .foregroundStyle(Color.accentColor)
                                }
                                Button(
                                    intent: ReloadWidgetIntent(),
                                    label: {
                                        Label(
                                            "Reload",
                                            systemImage: "arrow.clockwise"
                                        )
                                        .font(.caption)
                                        .labelStyle(.iconOnly)
                                })
                                .buttonStyle(.plain)
                                .foregroundStyle(Color.accentColor)
                            }
                        }
                    }
                    if item.note == nil || item.link == nil || item.link?.isEmpty == true {
                        Spacer()
                        HStack {
                            Spacer()
                            if item.viewed == false {
                                Button(
                                    intent: ItemViewedIntent(item: item),
                                    label: {
                                        Label(
                                            "Viewed",
                                            systemImage: "book"
                                        )
                                        .font(.caption)
                                        .labelStyle(.iconOnly)
                                })
                                .buttonStyle(.plain)
                                .foregroundStyle(Color.accentColor)
                            }
                            Button(
                                intent: ReloadWidgetIntent(),
                                label: {
                                    Label(
                                        "Reload",
                                        systemImage: "arrow.clockwise"
                                    )
                                    .font(.caption)
                                    .labelStyle(.iconOnly)
                            })
                            .buttonStyle(.plain)
                            .foregroundStyle(Color.accentColor)
                        }
                    }
                }
                .transition(.push(from: .bottom))
                .widgetURL(widgetURL)
            default:
                VStack(alignment: .leading) {
                    if let data = item.metadata?.siteImage, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    if item.link != nil {
                        Text(item.metadata?.title ?? item.link ?? "")
                            .font(.subheadline)
                            .bold()
                    }
                    if let note = item.note {
                        if item.link == nil || item.link?.isEmpty == true {
                            Spacer()
                        }
                        HStack(alignment: .bottom) {
                            Text(note)
                                .font(.caption)
                            if item.link != nil, item.link?.isEmpty == false {
                                Spacer()
                                if item.viewed == false {
                                    Button(
                                        intent: ItemViewedIntent(item: item),
                                        label: {
                                            Label(
                                                "Viewed",
                                                systemImage: "book"
                                            )
                                            .font(.caption)
                                            .labelStyle(.iconOnly)
                                    })
                                    .buttonStyle(.plain)
                                    .foregroundStyle(Color.accentColor)
                                }
                                Button(
                                    intent: ReloadWidgetIntent(),
                                    label: {
                                        Label(
                                            "Reload",
                                            systemImage: "arrow.clockwise"
                                        )
                                        .font(.caption)
                                        .labelStyle(.iconOnly)
                                })
                                .buttonStyle(.plain)
                                .foregroundStyle(Color.accentColor)
                            }
                        }
                    }
                    if item.note == nil || item.link == nil || item.link?.isEmpty == true {
                        Spacer()
                        HStack {
                            Spacer()
                            if item.viewed == false {
                                Button(
                                    intent: ItemViewedIntent(item: item),
                                    label: {
                                        Label(
                                            "Viewed",
                                            systemImage: "book"
                                        )
                                        .font(.caption)
                                        .labelStyle(.iconOnly)
                                })
                                .buttonStyle(.plain)
                                .foregroundStyle(Color.accentColor)
                            }
                            Button(
                                intent: ReloadWidgetIntent(),
                                label: {
                                    Label(
                                        "Reload",
                                        systemImage: "arrow.clockwise"
                                    )
                                    .font(.caption)
                                    .labelStyle(.iconOnly)
                            })
                            .buttonStyle(.plain)
                            .foregroundStyle(Color.accentColor)
                        }
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
    
    func getItem() -> Item? {
        if let item = unviewedItems.randomElement() {
            return item
        } else {
            return viewedItems.randomElement()
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
        .supportedFamilies([.accessoryRectangular, .accessoryInline, .systemSmall, .systemMedium, .systemLarge])
#endif
    }
}

#Preview(as: .accessoryRectangular) {
    MementoWidget()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}
