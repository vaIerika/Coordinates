//
//  DetailsView.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 01/05/2020.
//

import MapKit
import SwiftUI

struct DetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    var place: Place
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    place.image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: 510)
                        .clipped()
                        .edgesIgnoringSafeArea(.all)
                        .padding(.bottom, 32)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            CoordinatesView(latitude: place.latitude, longitude: place.longitude)
                            Spacer()
                        }
                        
                        Text(place.wrappedTitle)
                            .font(.largeTitle)
                            .padding(.bottom, 15)
                        Text(place.wrappedSubtitle.uppercased())
                            .font(.footnote)
                            .bold()
                        Text(place.details ?? "")
                            .font(.callout)
                            .opacity(0.7)                            
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 60)
                }
                .edgesIgnoringSafeArea(.top)
            }
            .navigationBarHidden(true)
            .labelsHidden()
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(place: Place())
    }
}
