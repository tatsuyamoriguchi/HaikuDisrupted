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
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
}
