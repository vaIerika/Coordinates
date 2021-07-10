//
//  ImageButtonView.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 10/07/2021.
//

import SwiftUI

struct ImageButtonView: View {
    var image: Image
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                image
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .overlay(
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 20))
                            .padding(.bottom, 40)
                            .padding(.trailing, 20),
                        alignment: .bottomTrailing
                    )
            }
        }
    }
}

struct ImageButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ImageButtonView(image: Image("default")) { }
    }
}
