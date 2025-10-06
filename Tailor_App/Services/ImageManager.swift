//
//  imageManager.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 05/10/2025.
//

import Foundation
import UIKit

class ImageManager  {
    static let shared = ImageManager()
    private init () {}
    
    func saveImage (_ image : UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else {return nil}
        let filename = UUID().uuidString + ".jpg"
        let fileUrl = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            try data.write(to: fileUrl)
        } catch  {
            return nil
        }
        return filename
    }
    func loadImage (_ filename : String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        return UIImage(contentsOfFile: fileURL.path)
    }
    func getDocumentsDirectory () -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
