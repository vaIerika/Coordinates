//
//  PlacesNearbyView.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 10/07/2021.
//

import SwiftUI

struct PlacesNearbyView: View {
    var latitude: Double
    var longitude: Double
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "location")
                    .foregroundColor(.blue)
                Text("Nearby to the place")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .leading) {
                if loadingState == .loaded {
                    ForEach(pages, id: \.pageid) { page in
                        VStack(alignment: .leading, spacing: 3) {
                            SelectableText(page.title)
                            SelectableText(page.description, secondary: true)
                        }
                        .padding(.bottom, 5)
                    }
                } else if loadingState == .loading {
                    Text("Loading...")
                } else {
                    Text("Please try again later ")
                }
            }
            .padding(.bottom, 40)
            .onAppear(perform: fetchNearbyPlaces)
        }
    }
    
    private func fetchNearbyPlaces() {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(latitude)%7C\(longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let items = try decoder.decode(WikiDataCodable.self, from: data)
                    pages = Array(items.query.pages.values).sorted()
                    loadingState = .loaded
                    return
                } catch {
                    print("Decoding failed. Data: \(String(bytes: data, encoding: .utf8) ?? "") Error: \(error.localizedDescription)")
                }
            }
            
            if let error = error {
                print("Request failed: \(error.localizedDescription)")
            }
            
            loadingState = .failed
        }
        .resume()
    }
}

struct PlacesNearbyView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesNearbyView(latitude: 15.20, longitude: 82.11)
    }
}
