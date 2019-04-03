//
//  HaikuViewController.swift
//  HaikuDisrupted
//
//  Created by Tatsuya Moriguchi on 3/25/19.
//  Copyright © 2019 Becko's Inc. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class HaikuViewController: UIViewController, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var managedObjectContext: NSManagedObjectContext? = nil
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    var wordCount: Int?
    var player: AVAudioPlayer?

    
    func playSound(mode: String) {
        
        var audio: String?
        
        switch mode {
        case "Opening":
            audio = "sukohn"
        case "Disrupting":
            
            //guard let url = Bundle.main.url(forResource: "Tequila", withExtension: "mp3") else { return }
            let soundArray = ["heaven", "hirameki1", "iyarasii", "kirakirakirarin", "kiran", "moyamoya", "munekyun", "omanuke2", "sukohn", "sukohn", "sukohn", "sukohn", "sengokustart", "soundlogo47", "soundlogo53", "wafu-syakuhachi", "wafu"]
            var count = soundArray.count
            print("count: \(count)")
            count = count - 1
            let index = Int(arc4random_uniform(UInt32(count)))
            print("index: \(index)")
            audio = soundArray[index]
        default:
            print("ERROR: playSound mode wasn't deteceted.")
        }

        
        guard let path = Bundle.main.path(forResource: audio, ofType: "mp3", inDirectory: "Audio") else {
            print("playSound() error")
            return
        }
        
        do {
        //    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)

          //  try AVAudioSession.sharedInstance().setActive(true)
  
            
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            guard let player = player  else {
                print("WTH")
                return }
            
            player.play()
            
        } catch {
            print("Audio error:(error.localizedDescription)")
            
        }
    }
    

    
    func randomWord(predicateType: String) -> String {
      
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
        //let adverbPredicate = NSPredicate(format: "type = 'adverb'")
        let wordPredicate = NSPredicate(format: "type = '\(predicateType)'")
        //let verbPredicate = NSPredicate(format: "type = 'verb'")
        //let adjectivePredicate = NSPredicate(format: "type = 'adjective'")

        fetchRequest.predicate = wordPredicate
        
        do { wordCount = try context.count(for: fetchRequest)
            //print("1 wordCount: \(String(describing: wordCount))")
        } catch { print(error) }
        
        let index = Int(arc4random_uniform(UInt32(wordCount!)))
        print("word index for \(predicateType) : \(index)")

        
        do {
            let objects = try context.fetch(fetchRequest)
            
            for object in objects {
                
                _ = (object as AnyObject).value(forKey: "word")
                
            }
            
            let randomWord = (objects[index] as AnyObject).value(forKey: "word")
            return randomWord as! String
            
        } catch  {
            print("Could not fetch: \(error)")
        }
        return "ERROR"
    }
 

    
    var todaysHaiku: String?
    var voice: String = ""
    var haikuImage: UIImage?
 
    
    
    
    // Properties
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var animal: UITextField!
    @IBOutlet weak var haiku: UITextView!
    
    

    
    
    @IBAction func tapToSelectImage(_ sender: UITapGestureRecognizer)  {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a photo.", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        } else {
            print("\n")
            print("Camera is not available.")
            print("\n")
        }
        
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            
            if let popoverController = actionSheet.popoverPresentationController{
                popoverController.sourceView = self.view
                
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                
                self.present(actionSheet, animated: true, completion: nil)
            }
        }else{
            self.present(actionSheet, animated: true, completion: nil)
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        
        //To avoid captured photo's orientation issue, use fixOrientation() see the extension of this file
        let orientationFixedImage = image?.fixOrientation()
        bgImage.image = orientationFixedImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }

    
    






    // MARK: haikuMakerOnPressed
    @IBAction func haikuMakerOnPressed(_ sender: Any) {
        
       
        switch animal.text {
        case "Type something here.":
            haiku.text = "Come on, yo  ..."
        case "":
            animal.text = "Type something here."
            
        default:
            
            // SoundEffect
            playSound(mode: "Disrupting")
            
            
            let verb = randomWord(predicateType: "verb")
            let adverb = randomWord(predicateType: "adverb")
            let adjective = randomWord(predicateType: "adjective")
            
            
            // Assembling words
            let part1 = animal.text ?? "No Animal"
            let part2 = " " + adverb + " " + verb + ", yet " + adjective
            todaysHaiku = part1 + part2
            
            
            // Background Ukiyoe Image
            let i3 = 15
            let num3 = Int(arc4random_uniform(UInt32(i3)))
            let num3String = String(num3)
            bgImage.image = UIImage (imageLiteralResourceName: num3String)
            haiku.alpha = 0.5
            
            
            // Dsiplay today's haiku
            haiku.text = todaysHaiku
            // Dismiss keyboard
            animal.resignFirstResponder()
            
            
            // text to speech with Japanese voice reading English
            let speechHaiku = AVSpeechUtterance(string: todaysHaiku!)
            speechHaiku.rate = 0.3
            //speechHaiku.preUtteranceDelay = 0.01

            // Check if there is a value for voiceType
            // If it exists, use it. If not, use ja-JP
            let userDefaults = UserDefaults.standard
            if let currentVoice = userDefaults.object(forKey: "voiceType") {
                voice = currentVoice as! String
                print(voice)

            } else {
                voice = "com.apple.ttsbundle.Kyoko-compact"
                print("voiceType didn't exist. Parhaps it hasn't been set in UserDefaults yet.")
            }
            
            speechHaiku.voice = AVSpeechSynthesisVoice(identifier: voice)
            let synth = AVSpeechSynthesizer()
            
            synth.speak(speechHaiku)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        playSound(mode: "Opening")
       
       
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        guard let segueID = segue.identifier else { return print("No segue ID was detected.")}
        guard let destinationVC = segue.destination as? TextToImageViewController else { return }
        
        //print("1:segueID: \(segueID)")
        if segueID == "ToTTISegue" {
            destinationVC.imageToDisplay = haikuImage
            destinationVC.CGRectToProcess = CGRectToProcess
            //destinationVC.textColorType = textColorType
        }
            
     }
    
    
    @IBOutlet var colorButtons: [UIButton]!
    
    
    @IBAction func selectColor(_ sender: UIButton) {
        

        colorSelectMenu()
        
    }

    let colorDict: [String: UIColor] = [
        "White": .white,
        "Black": .black,
        "Brown": .brown,
        "Light Gray": .lightGray,
        ]
    

    func colorSelectMenu() {
        colorButtons.forEach {(button) in
            button.isHidden = !button.isHidden
        }

    }

    var textColor: UIColor?
    
    @IBOutlet weak var textColorLabel: UIButton!
    
    @IBAction func colorTapped(_ sender: UIButton) {



        guard let title = sender.currentTitle, let color = colorDict[title] else {
            print("ERROR I knew it.")
            return }

        print("title: \(title) - color: \(color)")

        switch color {
        case .white:
            print("switch says white")
            textColor = colorDict["white"]
            textColorLabel.titleLabel?.text = "White"
            colorSelectMenu()
            
            
            
        case .black:
            print("switch says black")
            textColor = colorDict["black"]
            textColorLabel.titleLabel?.text = "Black"
            colorSelectMenu()

        case .lightGray:
            print("switch says lightGray")
            textColor = colorDict["lightGray"]
            textColorLabel.titleLabel?.text = "Light Gray"
            colorSelectMenu()

        case .brown:
            print("switch says brown")
            textColor = colorDict["brown"]
            textColorLabel.titleLabel?.text = "Brown"
            colorSelectMenu()

        default:
            print("Color Defaulted!")
            //textColor = .white
            textColorLabel.titleLabel?.text = "Color Defaulted!"
            colorSelectMenu()

        }
    }

    
    var CGRectToProcess: CGRect?
    
    @IBAction func textToImageOnPressed(_ sender: UIButton) {
        
        textColor = colorDict[(textColorLabel.titleLabel?.text)!]
        //print("textColor: \(textColor)")
        
        let imageToProcess = bgImage.image
        
        CGRectToProcess = bgImage.contentClippingRect
        
        haikuImage = TextToImage().textToImage(textColorType: textColor ?? .white, drawText: todaysHaiku ?? "ERROR No Haiku", inImage: imageToProcess!, atPoint: CGPoint(x: 10, y: 100))
        //bgImage.image = haikuImage
        
        
        
        performSegue(withIdentifier: "ToTTISegue", sender: self)
        
    }
    
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }

}
