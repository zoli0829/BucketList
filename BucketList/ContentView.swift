//
//  ContentView.swift
//  BucketList
//
//  Created by Zoltan Vegh on 06/05/2025.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    @State private var viewModel = ViewModel()
    
    @State private var showingHybridMap = false
        
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(.circle)
                                .contextMenu {
                                    Button("Edit Place") {
                                        viewModel.selectedPlace = location
                                    }
                                }
                        }
                    }
                }
                .mapStyle(showingHybridMap ? .hybrid : .standard)
                .overlay(alignment: .topTrailing) {
                    Button {
                        showingHybridMap.toggle()
                    } label: {
                        Image(systemName: "map")
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(.circle)
                    }
                    .padding()
                }
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.updateLocation(location: $0)
                        }
                    }
                    .alert("Authentication failed", isPresented: $viewModel.showAuthError) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Failed to authenticate. Please try again later.")
                    }
            }
        } else {
            Button("Unlock places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
