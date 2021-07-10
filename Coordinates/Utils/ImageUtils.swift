//
//  ImageUtils.swift
//  Coordinates
//
//  Created by Valerie 👩🏼‍💻 on 29/04/2020.
//

import Foundation

struct ImageUtils {
    func setImage(image: Data) -> String? {
        let url = getDocumentDirectory().appendingPathComponent(UUID().uuidString)

        do {
            try image.write(to: url, options: [.atomicWrite, .completeFileProtection])
            return url.lastPathComponent
        }
        catch let error {
            print("Could not write image: " + error.localizedDescription)
        }

        return nil
    }

    func getImage(imagePath: String?) -> Data? {
        guard let imagePath = imagePath else { return nil }

        let url = getDocumentDirectory().appendingPathComponent(imagePath)
        if let data = try? Data(contentsOf: url) {
            return data
        }

        return nil
    }

    func deleteImage(imagePath: String?) {
        guard let imagePath = imagePath else { return }

        do {
            let url = getDocumentDirectory().appendingPathComponent(imagePath)
            try FileManager.default.removeItem(at: url)
        }
        catch let error {
            print("Could not delete image: \(error.localizedDescription)")
        }
    }

    private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
