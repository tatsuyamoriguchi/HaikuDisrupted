//
//  VoicesViewController.swift
//  HaikuDisrupted
//
//  Created by Tatsuya Moriguchi on 3/26/19.
//  Copyright © 2019 Becko's Inc. All rights reserved.
//

import UIKit
import AVFoundation

class VoicesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var voicePicker: UIPickerView!
    
    
    var selected: String {
        return UserDefaults.standard.string(forKey: "voiceType") ?? "com.apple.ttsbundle.Kyoko-compact"
    }
    
    let speechVoices = AVSpeechSynthesisVoice.speechVoices()
    
    var voices = [String]()
    var languages = [String]()
    var identifiers = [String]()
    var currentVoice: String =  ""
    var row: Int = 0
    var selectedRow: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.voicePicker.delegate = self
        self.voicePicker.dataSource = self
        
        speechVoices.forEach { (voice) in
            voices.append(voice.name)
            languages.append(voice.language)
            identifiers.append(voice.identifier)
            
            if voice.identifier == selected {
                selectedRow = row
            }
            row += 1
        }
        

        voicePicker.selectRow(selectedRow, inComponent: 0, animated: false)

        // Do any additional setup after loading the view.
    }
    
    //
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    // PickerView the number of rows of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    //
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let localeDisplay = NSLocale(localeIdentifier: languages[row]).displayName(forKey: NSLocale.Key.identifier, value: languages[row]) ?? languages[row]
        let display = localeDisplay + " : " + voices[row]
        return display
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(identifiers[row], forKey: "voiceType")
        //print("identifiers[row] = \(identifiers[row])")
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
