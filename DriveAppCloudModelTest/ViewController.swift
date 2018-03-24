//
//  ViewController.swift
//  DriveAppCloudModelTest
//
//  Created by oliver dudler on 23.03.18.
//  Copyright © 2018 Oliver-Dudler. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Person>!
    
    var persons = ["Frieda", "Peter"]
    var hairColor = ["blonde", "brown"]
    var petRace = ["cat", "dog"]
    var petAge = [1,2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        attemptFetch()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let person = controller.object(at: indexPath as IndexPath)
        
        cell.personNameLabel.text = person.name
        cell.personHairColorLabel.text = person.haircolor
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let person = self.controller.object(at: indexPath as IndexPath)
            context.delete(person as NSManagedObject)
            ad.saveContext()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            
            case .insert:
                if let indexPath = newIndexPath {
                
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
                break
        
            case .update:
                break
        
            case .move:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ac = UIAlertController(title: "Add Pet", message: "Add a pet for the Person \(persons[indexPath.row])", preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Petname"
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Petage"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "Add", style: .default) { (_) in
            
//            guard let petRaceText = ac.textFields?.first?.text else { return }
//            guard let petAgeText = ac.textFields?[1].text else { return }
            
//            do something with these texts (enter them to cloud and coredata etc.)
            
        }
        
        ac.addAction(cancel)
        ac.addAction(add)
        
        present(ac, animated: true, completion: nil)
    }
    
    
    
    @IBAction func addPersonPressed(_ sender: Any) {
        
        let ac = UIAlertController(title: "Add Person", message: "Add a Person to your Personlist", preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Personname"
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Persons Haircolor"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "Add", style: .default) { (_) in
            
            guard let personNameText = ac.textFields?.first?.text else { return }
            guard let personHairColorText = ac.textFields?[1].text else { return }
            
//            do something with these texts (enter them to cloud and coredata etc.)
            
            let person = Person(context: context)
            
            person.name = personNameText
            person.haircolor = personHairColorText
            
            ad.saveContext()
            
            self.tableView.reloadData()
            
        }
        
        ac.addAction(cancel)
        ac.addAction(add)
        
        present(ac, animated: true, completion: nil)
    }
    
    
    
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [nameSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do {
            
            try controller.performFetch()
        } catch {
            
            print("\(error as NSError)")
        }
        print("attemptFetch called")
    }
    
}



