//
//  EditView.swift
//  BucketList
//
//  Created by Zoltan Vegh on 08/05/2025.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    
    @State private var viewModel: EditViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text:$viewModel.name)
                    TextField("Description", text:$viewModel.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                        case .loading:
                            Text("Loading...")
                        
                        case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                        
                        case .failed:
                            Text("Please try again later.")
                        }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = viewModel.location
                    newLocation.id = UUID()
                    newLocation.name = viewModel.name
                    newLocation.description = viewModel.description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        _viewModel = State(initialValue: EditViewModel(location: location))
        self.onSave = onSave
    }
}

#Preview {
    EditView(location: .example,) { _ in }
}
