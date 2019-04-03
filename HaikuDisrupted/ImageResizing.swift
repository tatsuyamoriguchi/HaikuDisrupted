//
//  ImageResizing.swift
//  HaikuDisrupted
//
//  Created by Tatsuya Moriguchi on 4/2/19.
//  Copyright © 2019 Becko's Inc. All rights reserved.
//

import Foundation
import UIKit

/*
//class ImageResizing: UIViewController {
extension UIImage {
    // UIKit Image Resizing
    func resizeUI(size:CGSize) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(size, true, self.scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
            
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resizedImage
        }
    
    // Core Graphics Image Resizing
    func resizeCG(size:CGSize) -> UIImage? {
        let bitsPerComponent = cgImage.bitsPerComponent(self.cgImage!)
        let bytesPerRow = cgImage.bytesPerRow(self.cgImage!)
        let colorSpace = cgImage.GetColorSpace(self.cgImage!)
        let bitmapInfo = cgImage.GetBitmapInfo(self.CGImage!)
        
        let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo.rawValue)
        CGContextSetInterpolationQuality(context, .High)
        
        CGContextDrawImage(context, CGRect(origin: CGPoint.zero, size: size), self.CGImage)
        
        return CGBitmapContextCreateImage(context).flatMap { UIImage(CGImage: $0) }
    }
    
    // Core Image Image Resizing
    func resizeCI(size:CGSize) -> UIImage? {
        let scale = (Double)(size.width) / (Double)(self.size.width)
        let image = UIKit.CIImage(cgImage:self.cgImage!)
        
        let filter = CIFilter(name: "CILanczosScaleTransform")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(NSNumber(value:scale), forKey: kCIInputScaleKey)
        filter.setValue(1.0, forKey:kCIInputAspectRatioKey)
        let outputImage = filter.value(forKey: kCIOutputImageKey) as! UIKit.CIImage
        
        let context = CIContext(options: [CIContextOption.useSoftwareRenderer: false])
        let resizedImage = UIImage(CGImage: context.createCGImage(outputImage, fromRect: outputImage.extent)!)
        return resizedImage
    }
    
    // vImage Image Resizing
    func resizeVI(size:CGSize) -> UIImage? {
        let cgImage = self.cgImage!
        
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.First.rawValue),
                                          version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.RenderingIntentDefault)
        var sourceBuffer = vImage_Buffer()
        defer {
            sourceBuffer.data.dealloc(Int(sourceBuffer.height) * Int(sourceBuffer.height) * 4)
        }
        
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // create a destination buffer
        let scale = self.scale
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bytesPerPixel = CGImageGetBitsPerPixel(self.CGImage) / 8
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.alloc(destHeight * destBytesPerRow)
        defer {
            destData.dealloc(destHeight * destBytesPerRow)
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        
        // create a CGImage from vImage_Buffer
        let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return nil }
        
        // create a UIImage
        let resizedImage = destCGImage.flatMap { UIImage(CGImage: $0, scale: 0.0, orientation: self.imageOrientation) }
        return resizedImage
    }
    
    
}
*/

/*

///////////////////////////////
//
//  TextToImageViewController.swift
//  HaikuDisrupted
//
//  Created by Tatsuya Moriguchi on 4/2/19.
//  Copyright © 2019 Becko's Inc. All rights reserved.
//

import UIKit

class TextToImageViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var imageForProcess: UIImageView!
    
    var imageToDisplay: UIImage?
    var CGRectToProcess: CGRect?
    
    var image: UIImage?
    var message: String?
    var url: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageForProcess.sizeToFit()
        imageForProcess.image = imageToDisplay
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func backToMainScreen(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareHaiku(_ sender: UIButton) {
        
        
        
        //image = UIImage(named: "koi")!
        image = imageToDisplay
        message = "Haiku Disrupted - Creating random Zen moments Available on App Store"
        url = URL(string: "http://beckos.com/")!
        
        
        
        let activityItems = [ActivityItemSource(message: message!), ActivityItemSourceImage(image: image!), ActivityItemSourceURL(url: url!)]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.markupAsPDF,
            //UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.openInIBooks,
            //UIActivity.ActivityType(rawValue: "com.snapchat.Share")
            //UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
            //UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),
        ]
        
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class ActivityItemSource: NSObject, UIActivityItemSource {
    
    var message: String!
    
    init(message: String) {
        self.message = message
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return message
        // to display Instagram button, return image
        // image: Mail, Message, Notes, Twitter, Instagram, Shared Album, Post to Google Maps, Messenger, LINE, Snapchat, Facebook
        // message: Mail, Message, Notes, Twitter, Messenger, LINE, Facebook, LinkedIn
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        switch activityType {
        case UIActivity.ActivityType.postToFacebook:
            return nil
        case UIActivity.ActivityType.postToTwitter:
            return message
        case UIActivity.ActivityType.mail:
            return message
        case UIActivity.ActivityType.copyToPasteboard:
            return message
        case UIActivity.ActivityType.markupAsPDF:
            return message
        case UIActivity.ActivityType.message:
            return message
        case UIActivity.ActivityType.postToFlickr:
            return message
        case UIActivity.ActivityType.postToTencentWeibo:
            return message
        case UIActivity.ActivityType.postToVimeo:
            return message
        case UIActivity.ActivityType.print:
            return message
        case UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"):
            return message
        case UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"):
            return message
        case UIActivity.ActivityType(rawValue: "com.burbn.instagram.shareextension"):
            return nil
        case UIActivity.ActivityType(rawValue: "jp.naver.line.Share"):
            return message
            
        default:
            return message
        }
    }
}


class ActivityItemSourceImage: NSObject, UIActivityItemSource {
    
    var image: UIImage?
    
    init(image: UIImage) {
        //self.image = UIImage(named: "AppIcon")!            //TextToImageViewController().imageForProcess.image
        self.image = TextToImageViewController().imageToDisplay ?? UIImage(named: "AppIcon")
    }
    
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        
        switch activityType {
        case UIActivity.ActivityType.saveToCameraRoll:
            return image
        case UIActivity.ActivityType.postToFacebook:
            return image
        case UIActivity.ActivityType.postToTwitter:
            return image
        case UIActivity.ActivityType.mail:
            return image
        case UIActivity.ActivityType.copyToPasteboard:
            return image
        case UIActivity.ActivityType.markupAsPDF:
            return image
        case UIActivity.ActivityType.message:
            return image
        case UIActivity.ActivityType.postToFlickr:
            return image
        case UIActivity.ActivityType.postToTencentWeibo:
            return image
        case UIActivity.ActivityType.postToVimeo:
            return image
        case UIActivity.ActivityType.print:
            return image
        case UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"):
            return image
        case UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"):
            return image
        case UIActivity.ActivityType(rawValue: "com.burbn.instagram.shareextension"):
            return image
        case UIActivity.ActivityType(rawValue: "jp.naver.line.Share"):
            return image
        default:
            return image
            
        }
    }
    
}


class ActivityItemSourceURL: NSObject, UIActivityItemSource {
    
    var url: URL!
    
    
    init(url: URL) {
        self.url = url
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return url
        
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        switch activityType {
        case UIActivity.ActivityType.postToFacebook:
            return url
        case UIActivity.ActivityType.postToTwitter:
            return url
        case UIActivity.ActivityType.mail:
            return url
        case UIActivity.ActivityType.copyToPasteboard:
            return nil
        case UIActivity.ActivityType.message:
            return url
        case UIActivity.ActivityType.postToFlickr:
            return url
        case UIActivity.ActivityType.postToTencentWeibo:
            return url
        case UIActivity.ActivityType.postToVimeo:
            return url
        case UIActivity.ActivityType.print:
            return url
        case UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"):
            return url
        case UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"):
            return url
        case UIActivity.ActivityType(rawValue: "com.burbn.instagram.shareextension"):
            return nil
        case UIActivity.ActivityType(rawValue: "jp.naver.line.Share"):
            return url
            //case UIActivity.ActivityType(rawValue: "com.snapchat.Share"):
            //  return nil
            
        default:
            return url
            
        }
    }
}

*/
