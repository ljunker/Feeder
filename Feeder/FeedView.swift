//
//  FeedView.swift
//  Feeder
//
//  Created by Lars Junker on 02.04.25.
//

import Foundation
import FeedKit

struct FeedItem: Identifiable {
    let id = UUID()
    let title: String
    let link: URL
    let pubDate: Date?
    let sourceName: String
    var isRead: Bool = false
}

struct FeedSource: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let name: String
    let link: URL
    
    init(name: String, link: URL) {
        self.id = UUID()
        self.name = name
        self.link = link
    }
}

class FeedViewModel: ObservableObject {
    @Published var selectedSource: FeedSource?
    @Published var sources: [FeedSource] = [] {
        didSet {
            saveSources()
        }
    }
    @Published var items: [FeedItem] = []
    
    private var readLinks: Set<URL> = []
    
    init() {
        loadReadItems()
        loadSources()
    }
    
    func addFeedSource(name: String, urlstring: String) {
        guard let url = URL(string: urlstring) else { return }
        let source = FeedSource(name: name, link: url)
        sources.append(source)
        loadFeed(from: source)
    }
    
    private func saveSources() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(sources) {
            UserDefaults.standard.set(data, forKey: "feedSources")
        }
    }
    
    private func loadSources() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "feedSources") {
            let savedSources: [FeedSource] = try! decoder.decode([FeedSource].self, from: data)
            self.sources = savedSources
            for source in savedSources {
                loadFeed(from: source)
            }
        }
    }
    
    private func loadReadItems() {
        if let saved = UserDefaults.standard.array(forKey: "readLinks") as? [String] {
            readLinks = Set(saved.compactMap { URL(string: $0) })
        }
    }
    
    func markItemAsRead(_ item: FeedItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isRead = true
            readLinks.insert(item.link)
            saveReadItems()
        }
    }
    
    private func saveReadItems() {
        let strings = readLinks.map { $0.absoluteString }
        UserDefaults.standard.set(strings, forKey: "readLinks")
    }
    
    func loadFeed(from source: FeedSource) {
        let parser = FeedParser(URL: source.link)
        parser.parseAsync {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let feed):
                    if let rssFeed = feed.rssFeed {
                        let loadedItems: [FeedItem] = rssFeed.items?.compactMap {
                            guard let title = $0.title,
                                  let link = $0.link,
                                  let url = URL(string: link) else { return nil }
                            let isRead = self.readLinks.contains(url)
                            return FeedItem(title: title, link: url, pubDate: $0.pubDate, sourceName: source.name, isRead: isRead)
                        } ?? []
                        self.items.append(contentsOf: loadedItems)
                    }
                case .failure(let error):
                    print("Error parsing feed: \(error)")
                }
            }
        }
    }
    
    func reloadAllSources() {
        self.items.removeAll()
        for source in sources {
            loadFeed(from: source)
        }
    }
    
    func itemsForSelectedSource() -> [FeedItem] {
        guard let source = selectedSource else { return [] }
        return items.filter({$0.sourceName == source.name})
    }
}
