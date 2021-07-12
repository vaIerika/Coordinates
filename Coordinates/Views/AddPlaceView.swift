//
//  AddPlaceView.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 01/05/2020.
//

import MapKit
import SwiftUI

struct AddPlaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Place.entity(), sortDescriptors: []) var places: FetchedResults<Place>
    
    @Binding var placemark: MKPointAnnotation
    
    @State private var image = Image("default")
    @State private var imageSourceType: ImageSourceType = .library
    @State private var showingImagePicker = false
    @State private var uiImage: UIImage?
    @State private var placeDescription = ""
    
    @State private var errorAlertMessage = ""
    @State private var showingErrorAlert = false
    @State private var showActionSheet = false
    
    /// monitor keyboard events to allow scrolling when it appears
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                ImageButtonView(image: image) { showActionSheet = true }
                
                VStack(alignment: .leading) {
                    HStack {
                        Button("Dismiss") {
                            presentationMode.wrappedValue.dismiss()
                        }
                            .foregroundColor(.red)
                        Spacer()
                        Button("Save") { addPlace() }
                    }.layoutPriority(3)
                    
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
                    
                    PlacesNearbyView(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
                }
                .padding(.horizontal, 25)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .offset(x: 0, y: -35)
                        .foregroundColor(.white)
                )
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: $uiImage, sourceType: imageSourceType)
                }
                .alert(isPresented: $showingErrorAlert) {
                    Alert(title: Text(errorAlertMessage))
                }
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text("Add your picture to the place"), message: nil, buttons: [
                        .default(Text("Take a photo"), action: {
                            takePicture()
                        }),
                        .default(Text("Choose from gallery"), action: {
                            selectPhoto()
                        }),
                        .cancel()
                    ])
                }
            }
            .padding(.bottom, keyboard.currentHeight)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func addPlace() {
        guard !(placemark.title == nil) else {
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

        presentationMode.wrappedValue.dismiss()
    }
    
    private func loadImage() {
        guard let uiImage = uiImage else { return }
        image = Image(uiImage: uiImage)
    }
    
    private func takePicture() {
        if ImagePicker.isCameraAvailable() {
            imageSourceType = .camera
            showingImagePicker = true
        } else {
            errorAlertMessage = "Camera is not available"
            showingErrorAlert = true
        }
    }
    
    private func selectPhoto() {
        imageSourceType = .library
        showingImagePicker = true
    }
}

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView(placemark: .constant(.example))
    }
}
