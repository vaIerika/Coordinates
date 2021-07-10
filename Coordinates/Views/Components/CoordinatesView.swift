//
//  CoordinatesView.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 06/05/2020.
//

import SwiftUI

struct CoordinatesView: View {
    var latitude: Double
    var longitude: Double
    
    var body: some View {
        HStack(spacing: 0) {
            Image("pin")
                .padding(.trailing, 10)
            Text("\(Int(latitude))° \(latitude >= 0 ? "N, " : "S, ")")
            Text("\(Int(longitude))° \(longitude >= 0 ? " E" : " W")")
        }
        .font(.footnote)
        .foregroundColor(.gray)
    }
}

struct CoordinatesView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatesView(latitude: 12.32, longitude: 14.21)
    }
}
