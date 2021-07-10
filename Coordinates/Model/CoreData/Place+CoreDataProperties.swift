//
//  Place+CoreDataProperties.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 30/04/2020.
//
//

import Foundation
import CoreData
import UIKit
import SwiftUI

extension Place {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }
    
    @NSManaged public var details: String?
    @NSManaged public var id: UUID?
    @NSManaged public var imagePath: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    
    public var wrappedTitle: String {
        title ?? "Unknown"
    }
    
    public var wrappedSubtitle: String {
        subtitle ?? "No description"
    }
    
    public var exampleImageName: String {
        if let _ = UIImage(named: wrappedTitle) {
            return wrappedTitle
        } else {
            return "default"
        }
    }
    
    public var image: Image {
        if let data = ImageUtils().getImage(imagePath: imagePath) {
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            }
        }
        return Image(exampleImageName)
    }
}
