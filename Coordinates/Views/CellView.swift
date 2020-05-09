//
//  CellView.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 05/05/2020.
//

import SwiftUI

struct CellView: View {
    var place: Place
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            place.image
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 140)
                .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                CoordinatesView(latitude: place.latitude, longitude: place.longitude)
                    .padding(.top, 10)
                    .padding(.bottom, 8)
                Text(place.wrappedTitle)
                    .font(.headline)
                Text(place.wrappedSubtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .multilineTextAlignment(.leading)
            .lineLimit(3)
        }
        .padding(.vertical, 15)
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(place: Place())
    }
}
