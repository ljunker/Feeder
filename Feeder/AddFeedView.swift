//
//  AddFeedView.swift
//  Feeder
//
//  Created by Lars Junker on 02.04.25.
//

import SwiftUI

struct AddFeedView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: FeedViewModel
    
    @State private var name = ""
    @State private var url = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Feed-URL", text: $url)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
            }
            .navigationTitle("Feed hinzufügen")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Hinzufügen") {
                        viewModel.addFeedSource(name: name, urlstring: url)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
        }
    }
}
