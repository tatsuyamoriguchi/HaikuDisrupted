//
//  UserDefaultsProcess.swift
//  HaikuDisrupted
//
//  Created by Tatsuya Moriguchi on 3/26/19.
//  Copyright © 2019 Becko's Inc. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsProcess: UIViewController {

    func saveVoice(newVoice: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(newVoice, forKey: "voiceType")
    }
    

}

