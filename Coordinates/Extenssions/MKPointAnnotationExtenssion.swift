//
//  MKPointAnnotationExtenssion.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 29/04/2020.
//

import MapKit
import UIKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? ""
        }
        set {
            title = newValue
        }
    }

    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? ""
        }
        set {
            subtitle = newValue
        }
    }
}

extension MKPointAnnotation: Identifiable {
    public var id: String { wrappedTitle + "\(coordinate.latitude)" + "\(coordinate.longitude)" }
}

// MARK: - For preview
extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "Bratislava"
        annotation.subtitle = "Capital of the Slovakia"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 48.148598, longitude: 17.107748)
        return annotation
    }
}
