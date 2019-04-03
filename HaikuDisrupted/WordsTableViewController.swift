//
//  WordsTableViewController.swift
//  HaikuDisrupted
//
//  Created by Tatsuya Moriguchi on 3/27/19.
//  Copyright © 2019 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class WordsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // Properties to pass to AddWordViewController via segue
    //var selectedWord: String?
    //var selectedWordType: String?
    var segueID: String?
    var types: Array = [String]()
    var selectedCell: UITableViewCell?
    
    //
    var managedObjectContext: NSManagedObjectContext? = nil
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // Provide a change type when leadingSwipe or didSelectedRow
    public enum NSFetchedResultsChangeType : Int {
        case insert
        case delete
        case move
        case update
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         DispatchQueue.main.async {
            self.tableView.reloadData()
        }
         */
        
        configureFetchedResultsController()

       // tableView.delegate = self
        //tableView.dataSource = self


 //       NotificationCenter.default.addObserver(self, selector: #selector(MessagesTab.dataChanged), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: self.mainThreadMOC)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func configureFetchedResultsController() {
        // Get a reference to AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
        let sortDescriptorByWord = NSSortDescriptor(key: "word", ascending: true)
        let sortDescriptorByType = NSSortDescriptor(key: "type", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptorByType, sortDescriptorByWord]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: "type", cacheName: nil)
        fetchedResultsController?.delegate = self
       
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
       
        let rowCount = sections[section].numberOfObjects
        
        //print("The Amount of rows in the section are: \(rowCount)")
        return rowCount
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        //print("sections.count: \(sections.count)")
        return sections.count
        
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let sections = fetchedResultsController?.sections {
            let currentSection = sections[section]
            
           // Populate an array for segue, toEditWordSegue
            if types.contains(currentSection.name) {
            } else {
                types.append(currentSection.name)
            }
            
            return currentSection.name
            
        }
        
        return nil
        
    }
    

    
/*
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        headerView.backgroundColor = UIColor.purple
        //headerView.tintColor = UIColor.black
        return headerView
        
    }
    

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let titleView = view as? UITableViewHeaderFooterView
        titleView?.textLabel?.textColor = UIColor.black
        
    }
*/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordsCell", for: indexPath)
        
        configureCell(cell, at: indexPath)
        /*
        if let word = fetchedResultsController?.object(at: indexPath) as? Word {
            cell.textLabel?.text = word.word
            cell.detailTextLabel?.text = word.type
        }
        */

        return cell
    }
    
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        self.configureCell(cell!, at: indexPath)
        self.selectedCell = cell
    
    }
 
    
    // Edit/Update an existing word.
    // Trailing segues to another ViewController
    // Make delete with trailingSwipeActinsconfigurationForRowAt, later
   /* override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view,
                                                                        actionPerformed: (Bool) -> Void) in
            
            
            let cell = tableView.cellForRow(at: indexPath)
            self.configureCell(cell!, at: indexPath)
            self.selectedCell = cell
            
            /*
            if let word = self.fetchedResultsController?.object(at: indexPath) as? Word {
                self.selectedWord = word.word
                self.selectedWordType = word.type
            }
            */
            self.performSegue(withIdentifier: "toEditWordSegue", sender: self)
            
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("IndexPath of delete: \(indexPath)")
            completionHandler(true)
        }

       return UISwipeActionsConfiguration.init(actions: [edit, delete])
    }
    */
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //tableView.beginUpdates()
    }
    
    
/*
     func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
     didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int,
     for type: NSFetchedResultsChangeType) {
 */
    private func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        print("NSFetchResultController didChange NSFetchedResultsChangeType \(type.rawValue):)")
        
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)

                /*
                /*calculate indexSet based of current section*/
                let indexSet = NSIndexSet(index: indexPath.section)
                /*insert section at this indexSet using table view insertSections method*/
                tableView.insertSections(indexSet as IndexSet, with: .fade)
                 */
            }
            break;
        case .delete:
           if let indexPath = indexPath {
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
                /*
                /*calculate indexSet based of current section*/
                let indexSet = NSIndexSet(index: indexPath.section)
                
                /*delete section at this indexSet using table view deleteSections method*/
                tableView.deleteSections(indexSet as IndexSet, with: .fade)
                */
            }
           //break;
  
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                configureCell(cell, at: indexPath)
                
            }
            break;
 
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
               
                /*
                let indexSet = NSIndexSet(index: indexPath.section)
                tableView.deleteSections(indexSet as IndexSet, with: .fade)
                 */
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)

                /*let indexSet = NSIndexSet(index: newIndexPath.section)
                tableView.insertSections(indexSet as IndexSet, with: .fade)
                 */
                
            }
            break;
            
        }
    }
/*
    private func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            let sectionIndexSet = NSIndexSet(index: sectionIndex)
            self.tableView.insertSections(sectionIndexSet as IndexSet, with: .fade)
        case .delete:
            let sectionIndexSet = NSIndexSet(index: sectionIndex)
            self.tableView.deleteSections(sectionIndexSet as IndexSet, with: .fade)
            
            /*
             /*calculate indexSet based of current section*/
             let indexSet = NSIndexSet(index: indexPath.section)
             
             /*delete section at this indexSet using table view deleteSections method*/
             tableView.deleteSections(indexSet as IndexSet, with: .fade)
             */
        default:
            break
            
        }
            
    }
  */
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("The Controller Content has changed.")
        
        tableView.reloadData()
        
       //tableView.endUpdates()
    }
    
 
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        // Fetch Word
        if let word = fetchedResultsController?.object(at: indexPath) as? Word {
        // Configure Cell
        cell.textLabel?.text = word.word
        cell.detailTextLabel?.text = word.type
        }
    }

    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
   // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source.
            let wordToDelete = fetchedResultsController?.object(at: indexPath)
            
            context.delete(wordToDelete as! NSManagedObject)
            
            do {
                try context.save()
            } catch {
                print("Saving Error: \(error)")
                // Error occured while deleting objects
            }

            

            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        
    }

    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
  
        guard let segueID = segue.identifier else { return print("No segue ID was detected.")}
        guard let destinationVC = segue.destination as? AddWordViewController else { return }
      
        //print("1:segueID: \(segueID)")
        if segueID == "toAddWordSegue" {
            destinationVC.segueID = segueID
            destinationVC.types = types
           
        } else if segueID == "toEditWordSegue" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return print("something wrong.")}
            
            // Fetch word
            let word = fetchedResultsController?.object(at: indexPath)
            
            destinationVC.word = word as? Word
            //destinationVC.selectedType = word.type
            destinationVC.segueID = segueID
            

/*            destinationVC.selectedWord = selectedWord
            destinationVC.selectedWordType = selectedWordType
 */
            //destinationVC.selectedIndex = selectedIndex
            destinationVC.types = types
            
        } else { print("Unknown Error, parhaps related to segue")}
    }
    

}
/*
extension UITableViewController: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("The Controller Contetn has changed.")
        tableView.reloadData()
    }
}
*/
