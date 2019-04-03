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

        image = imageToDisplay

        do {
            let activityViewController = UIActivityViewController(activityItems: [self.image], applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                if activityViewController.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                    activityViewController.popoverPresentationController?.sourceView = self.view
                }
            }
            
            
            present(activityViewController, animated: true)
        
        } catch let error {
            print("shareHaiku error: \(error)")
        }
      
        
        
    }

/*        //image = UIImage(named: "koi")!
        image = imageToDisplay
        //message = "Haiku Disrupted - Creating random Zen moments Available on App Store"
        //url = URL(string: "http://beckos.com/")!

        
        
        let activityItems = image
            //[ActivityItemSourceImage(image: image!)]
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



    
    init(image: UIImage) {
        //self.image = UIImage(named: "AppIcon")!            //TextToImageViewController().imageForProcess.image
        self.image = imageToDisplay ?? UIImage(named: "AppIcon")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
*/
}


