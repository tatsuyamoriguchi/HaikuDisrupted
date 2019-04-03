//
//  AddWordViewController.swift
//  HaikuDisrupted
//
//  Created by Tatsuya Moriguchi on 3/29/19.
//  Copyright © 2019 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class AddWordViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
  
    var segueID: String?
    //var selectedWord: String?
    //var selectedWordType: String?
    var types = [String]()
    var selectedRow: Int = 0
    var row: Int = 0
    
    var word: Word?
    //var selectedIndex: Int?
    var selectedType: String?
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var typePicker: UIPickerView!
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func button(_ sender: Any) {
        
 
  
        if wordTextField.text == "" {
            wordTextField.text = "Type a word here."
            
        } else {
            
            switch segueID {
                
            case "toAddWordSegue":
                print("Add a new word.")
                /*guard let _context = managedObjectContext else {   return  }
                
 */

                //let newWord = NSManagedObject(entity: Word?, insertInfo: context)
                let entity = NSEntityDescription.entity(forEntityName: "Word", in: context)
                let newWord = NSManagedObject(entity: entity!, insertInto: context)
                newWord.setValue(wordTextField.text, forKey: "word")
                
                //let selectedType = pickerView(typePicker, titleForRow: selectedRow, forComponent: 0)
               
                newWord.setValue(selectedType, forKey: "type")
                
                
                
            case "toEditWordSegue":
                
                word?.word = wordTextField.text
                //let selectedType = pickerView(typePicker, titleForRow: selectedRow, forComponent: 0)
                // BUG: The following line assigns a wrong type or nil
                word?.type = selectedType

                
                /*            // if updating word data
                 word?.word = wordTextField.text
                 let selectedType = pickerView(typePicker, titleForRow: selectedRow, forComponent: 0)
                 word?.type = selectedType
                 
                 do { try context.save() } catch { print("New Word Saving Error: \(error.localizedDescription)") }
                 */
            default:
                print("segueID wasn't any of precoded ones")
            }
 
            do { try context.save() } catch { print("New Word Saving Error: \(error.localizedDescription)") }

            navigationController!.popViewController(animated: true)
    
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.typePicker.delegate = self
        self.typePicker.dataSource = self
        
   
        // Check segueID to display button's label text 
        if segueID == "toAddWordSegue" {
            buttonLabel.setTitle("Add a Word", for: .normal)
        } else if segueID == "toEditWordSegue" {
            
            buttonLabel.setTitle("Update a Word", for: .normal)
            //wordTextField.text = selectedWord
            wordTextField.text = word?.word
            
            
        } else {
            buttonLabel.setTitle("ERROR: No segueID was detected", for: .normal)
        }
        
        // Check the type of the word to edit for Picker
        for ty in types {
            /*
             if ty == selectedWordType {
             selectedRow = row
             break;
             }
             */
            if ty == word?.type {
                selectedRow = row
                break;
            }
            row += 1
            
        }
 
        typePicker.selectRow(selectedRow, inComponent: 0, animated: false)
      
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //let valueSelected = types[row] as String
        
        selectedType = types[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // types[row] when deleting all words of a type, pickerView won't show that type.
        // Preset array presetTypes = ["adjective", "adverb", "verb"] may display a wrong type for a word
        return types[row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //guard let segueID = segue.identifier else { return print("No segue ID was detected.")}
        //guard let destinationVC = segue.destination as? WordsTableViewController else { return }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
