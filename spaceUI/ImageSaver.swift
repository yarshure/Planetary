//
//  a.swift
//  spaceUI
//
//  Created by Apple on 21/6/2021.
//

import Foundation
import UIKit
class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            // save complete
        if let e = error {
            print(e)
        }
        
    }
}
