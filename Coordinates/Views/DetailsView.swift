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
            ScrollView(.vertical) {
                VStack {
                    self.place.image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: 510)
                        .clipped()
                        .edgesIgnoringSafeArea(.all)
                        .padding(.bottom, 32)
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            CoordinatesView(latitude: self.place.latitude, longitude: self.place.longitude)
                            Spacer()
                        }
                        
                        Text(self.place.wrappedTitle)
                            .font(.largeTitle)
                            .padding(.bottom, 15)
                        Text(self.place.wrappedSubtitle.uppercased())
                            .font(.footnote)
                            .bold()
                            .fixedSize(horizontal: false, vertical: true)
                        Text(self.place.details ?? "")
                            .font(.callout)
                            .opacity(0.7)
                            .fixedSize(horizontal: false, vertical: true)
                    }
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
