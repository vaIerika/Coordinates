//
//  MapView.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 29/04/2020.
//

import MapKit
import SwiftUI

struct MapView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Place.entity(), sortDescriptors: []) var places: FetchedResults<Place>
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [MKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingAddPlaceView = false
    @State private var showingPlaceDetails = false
    @State private var showingPlaceDetailsView = false
    
    
    var body: some View {
        ZStack {
            MapUIView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        addNewLocation()
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                }
            }
        }
        .labelsHidden()
        .onAppear(perform: getAnnotations)
        .sheet(isPresented: $showingPlaceDetails) {
            if self.selectedPlace != nil {
                DetailsView(place: self.getData(for: self.selectedPlace!))
            }
        }
            
        /// func navigate - an extension to the View, replace usage of 2nd .sheet()
        .navigate(to: AddPlaceView(placemark: self.selectedPlace ?? MKPointAnnotation.example), when: $showingAddPlaceView)
    }
    
    private func addNewLocation() {
        let newLocation = MKPointAnnotation()
        newLocation.coordinate = centerCoordinate
        locations.append(newLocation)
        selectedPlace = newLocation
        showingAddPlaceView = true
    }
    
    private func getAnnotations() {
        for place in places {
            let annotation = MKPointAnnotation()
            annotation.title = place.title
            annotation.subtitle = place.subtitle
            annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            locations.append(annotation)
        }
    }
    
    private func getData(for annotation: MKPointAnnotation) -> Place {
        if let index = places.firstIndex(where: { place in
            place.latitude == annotation.coordinate.latitude &&
                place.longitude == annotation.coordinate.longitude
        }) {
            return places[index]
        }
        return places[0]
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
