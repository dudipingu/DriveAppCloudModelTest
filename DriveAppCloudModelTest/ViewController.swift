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
    
    var personController: NSFetchedResultsController<Person>!
    
    var petController: NSFetchedResultsController<Pet>!
    
    let database = CKContainer.default().privateCloudDatabase
    
    var persons = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        attemptFetch()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let person = personController.object(at: indexPath as IndexPath)
        
        cell.personNameLabel.text = person.name
        cell.personHairColorLabel.text = person.haircolor
        
        cell.petLabel.text = createPetString(forPerson: person)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = personController.sections {
            
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
            
            let person = self.personController.object(at: indexPath as IndexPath)
            context.delete(person as NSManagedObject)
            ad.saveContext()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if controller == personController {
        
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ac = UIAlertController(title: "Add Pet", message: "Add a pet for the Person \(String(describing: personController.object(at: indexPath).name))", preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Petname"
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Petage"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "Add", style: .default) { (_) in
            
        guard let petRaceText = ac.textFields?.first?.text else { return }
        guard let petAgeText = ac.textFields?[1].text else { return }
            
            let pet = Pet(context: context)
            
            pet.race = petRaceText
            pet.age = petAgeText
            pet.person = self.personController.object(at: indexPath)
            
            ad.saveContext()
            
            self.tableView.reloadData()
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
    
    @IBAction func pushToCloud(_ sender: Any) {
        
        //1 deletes the whole cloud (all person entities)
        
        let query = CKQuery(recordType: "Person", predicate: NSPredicate(value:true))
        database.perform(query, inZoneWith: nil) { (records, _) in
            
            guard let records = records else { return }
            
            for record in records  {
                
                self.database.delete(withRecordID: record.recordID, completionHandler: { (recordID, error) in
                    
                    if let error = error {
                        
                        print(error)
                    } else {
                        
                        print("deleted succesfully")
                    }
                })
            }
        }
        
        //get all core data data  with this fetch and save it in personController
        
        attemptFetch()
        
        let sectionInfo = personController.sections![0]
        let numberOfPersons = sectionInfo.numberOfObjects
        
        // for every core data person create a new ckrecord (nothign done with pets yet)
        
        for person in 0..<numberOfPersons {
            
            let person = personController.object(at: IndexPath(row: person, section: 0))
            
            let newPerson = CKRecord(recordType: "Person")
            newPerson.setValue(person.haircolor, forKey: "hairColor")
            newPerson.setValue(person.name, forKey: "name")
            
            database.save(newPerson) { (record, Error) in
                guard record != nil else  { return }
                print("saved record")
            }
        }
        
        //problem: its not called in order how it should, we have to work with dispatchgroups and completion handlers, but im not quite familiar with them yet....
        
    }
    
    @IBAction func pullFromCloud(_ sender: Any) {
        
        //nothing in here yet
        
        print(self.persons.count)
    }
    
    func queryDatabase() {
        
        
        
    }
    
    
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [nameSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.personController = controller
        
        do {
            
            try controller.performFetch()
        } catch {
            
            print("\(error as NSError)")
        }
        print("attemptFetch called")
    }
    
    func createPetString(forPerson person: Person) -> String {
        
        var petString = ""
        
        let petArray = person.pet?.allObjects as! [Pet]
        
        for pet in petArray {
            
            petString += pet.race! + " " + pet.age! + "|" + " "
        }
        
        return petString
    }
    
}



