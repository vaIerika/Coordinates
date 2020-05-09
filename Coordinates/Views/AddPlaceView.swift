//
//  AddPlaceView.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 01/05/2020.
//

import MapKit
import SwiftUI

enum LoadingState {
    case loading, loaded, failed
}

struct AddPlaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Place.entity(), sortDescriptors: []) var places: FetchedResults<Place>
    
    @ObservedObject var placemark: MKPointAnnotation
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    @State private var image = Image("default")
    @State private var imageSourceType: ImageSourceType = .library
    @State private var showingImagePicker = false
    @State private var uiImage: UIImage?
    @State private var placeDescription = ""
    @State private var errorAlertMessage = ""
    @State private var showingErrorAlert = false
    @State private var showActionSheet = false
    
    // monitor keyboard events to allow scrolling when it appears
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                ZStack {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(minHeight: 40, idealHeight: 300, maxHeight: 300)
                        .clipped()
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "pencil.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .padding(.bottom, 50)
                                .padding(.trailing, 30)
                        }
                    }
                }
                .onTapGesture {
                    self.showActionSheet = true
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Dismiss")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Button("Save") {
                            self.addPlace()
                        }
                    }
                    
                    HStack {
                        Text("Coordinates of the place")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        CoordinatesView(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
                    }
                    .padding(.top, 25)
                    .padding(.bottom, 10)
                    
                    TextField("Name the place", text: $placemark.wrappedTitle)
                        .font(.callout)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue)
                                .opacity(0.6)
                        )
                        .padding(.bottom, 10)
                    
                    MultilineTextField("Short description", text: $placemark.wrappedSubtitle)
                        .padding(.bottom, 10)
                    
                    MultilineTextField("Additional details", text: $placeDescription)
                        .padding(.bottom, 35)
                    
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
                .padding(.horizontal, 25)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .offset(x: 0, y: -35)
                        .foregroundColor(.white)
                )
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$uiImage, sourceType: self.imageSourceType)
                }
                .alert(isPresented: $showingErrorAlert) {
                    Alert(title: Text(errorAlertMessage))
                }
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text("Add your picture to the place"), message: nil, buttons: [
                        .default(Text("Take a photo"), action: {
                            self.takePicture()
                        }),
                        .default(Text("Choose from gallery"), action: {
                            self.selectPhoto()
                        }),
                        .cancel()
                    ])
                }
            }
            .padding(.bottom, keyboard.currentHeight)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func addPlace() {
        guard !(self.placemark.title == nil) else {
            errorAlertMessage = "Please provide a name to save the place"
            showingErrorAlert = true
            return
        }
        
        let newPlace = Place(context: moc)
        newPlace.id = UUID()
        newPlace.title = placemark.title
        newPlace.subtitle = placemark.subtitle
        newPlace.details = placeDescription
        newPlace.latitude = placemark.coordinate.latitude
        newPlace.longitude = placemark.coordinate.longitude
        
        if let uiImage = uiImage {
            if let jpegData = uiImage.jpegData(compressionQuality: 0.8) {
                let str = ImageUtils().setImage(image: jpegData)
                newPlace.imagePath = str
            }
        }
        
        try? self.moc.save()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func fetchNearbyPlaces() {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placemark.coordinate.latitude)%7C\(placemark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let items = try decoder.decode(WikiDataCodable.self, from: data)
                    self.pages = Array(items.query.pages.values).sorted()
                    self.loadingState = .loaded
                    return
                } catch {
                    print("Decoding failed. Data: \(String(bytes: data, encoding: .utf8) ?? "") Error: \(error.localizedDescription)")
                }
            }
            
            if let error = error {
                print("Request failed: \(error.localizedDescription)")
            }
            
            self.loadingState = .failed
        }
        .resume()
    }
    
    func loadImage() {
        guard let uiImage = self.uiImage else { return }
        self.image = Image(uiImage: uiImage)
    }
    
    func takePicture() {
        if ImagePicker.isCameraAvailable() {
            self.imageSourceType = .camera
            self.showingImagePicker = true
        } else {
            self.errorAlertMessage = "Camera is not available"
            self.showingErrorAlert = true
        }
    }
    
    func selectPhoto() {
        self.imageSourceType = .library
        self.showingImagePicker = true
    }
}

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView(placemark: .example)
    }
}
