//
//  TextToImage.swift
//  HaikuDisrupted
//
//  Created by Tatsuya Moriguchi on 4/2/19.
//  Copyright © 2019 Becko's Inc. All rights reserved.
//

import Foundation
import UIKit

class TextToImage: UIViewController {
    
    

    ///////////////////////////////////////
    // Detect the file size of image. Some SNS sites like Facebook have a connection issue
    // when uploading a large file size image
    
    func detectImageFileSize(imageName: UIImage) -> Int {
        
        // anyway to detext file type, png, jpg, gif, tiff?
        //let imageData: Data = imageName.pngData()!
        let imageData: Data = imageName.jpegData(compressionQuality: 1)!
        var imageFileSize = imageData.count
        
        print("Size of image in KB: %f ", Double(imageFileSize) / 1024.0)
        print("Size of image in byte: %f ", imageFileSize)
        return imageFileSize
    }
    ///////////////////////////
    // Detect CGSize of image
    // Use let imageSize = CGSize(width: image.size.width, height: image.size.height)

    
    ///////////////////////////
    // Reduce image file size
    func reduceImageFileSize(image: UIImage, imageSize: CGSize) -> UIImage {
        let newImageSize = CGSize(width: imageSize.width / 2, height: imageSize.height / 2)
        
        print("newImageSize: \(newImageSize)")
        
        let rect = CGRect(x: 0, y: 0, width: newImageSize.width, height: newImageSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    ////////////////////////////
    
    
    
    
    
    
    func textToImage(textColorType: UIColor, drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        print("image.size wdth: \(image.size.width) & height: \(image.size.height)")


        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let imageTotal = imageWidth + imageHeight
        let imageFactor = imageTotal / 25
        print("imageFactor: \(imageFactor)")
        
        let textColor = textColorType
        
        let textFontSize = imageFactor
        print("textFontSize: \(textFontSize)")
        let textFont = UIFont(name: "Papyrus", size: CGFloat(textFontSize))!
        

        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            
            ] as [NSAttributedString.Key : Any]
    
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let appNameText = "Accidental Zen Moment from Haiku Disrupted iOS App"
        let appNameCGPoint = CGPoint(x: 3, y: 3)
        let appNameRect = CGRect(origin: appNameCGPoint, size: image.size)
        
        let textFontSizeForAppName = imageFactor / 2
        let textFontForAppName = UIFont(name: "Papyrus", size: CGFloat(textFontSizeForAppName))!
        let textFontAttributesForAppName = [
            NSAttributedString.Key.font: textFontForAppName,
            NSAttributedString.Key.foregroundColor: textColor,]
        as [NSAttributedString.Key : Any]
        
        appNameText.draw(in: appNameRect, withAttributes: textFontAttributesForAppName)
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
}

