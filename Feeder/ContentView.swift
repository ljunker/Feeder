//
//  ContentView.swift
//  Feeder
//
//  Created by Lars Junker on 02.04.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var selectedURL: URL?
    @State private var showingAddFeed = false
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.sources.isEmpty {
                    Picker("Quelle", selection: $viewModel.selectedSource) {
                        ForEach(viewModel.sources, id: \.id) { source in
                            Text(source.name).tag(Optional(source))
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                }
                List {
                    ForEach(viewModel.itemsForSelectedSource()) { item in
                        Button(action: {
                            viewModel.markItemAsRead(item)
                            selectedURL = item.link
                        }) {
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                    .foregroundColor(item.isRead ? .gray : .primary)
                                if let date = item.pubDate {
                                    Text(date, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("RSS Reader")
            .toolbar {
                Button(action: {
                    viewModel.reloadAllSources()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                Button(action: {
                    showingAddFeed = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(item: $selectedURL) { url in
                SafariView(url: url)
            }
            .sheet(isPresented: $showingAddFeed) {
                AddFeedView(viewModel: viewModel)
            }
            .onAppear {
                if viewModel.selectedSource == nil, let first = viewModel.sources.first {
                    viewModel.selectedSource = first
                }
            }
        }
    }
}

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}

#Preview {
    ContentView()
}
