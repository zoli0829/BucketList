//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Zoltan Vegh on 11/05/2025.
//

import Foundation

@Observable
class EditViewModel {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    var name: String
    var description: String
    var loadingState = LoadingState.loading
    var pages = [Page]()
    
    let location: Location
    
    init(location: Location) {
        self.location = location
        self.name = location.name
        self.description = location.description
    }
    
    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad url: \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }
}
