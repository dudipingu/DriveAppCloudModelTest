//
//  ViewController.swift
//  DriveAppCloudModelTest
//
//  Created by oliver dudler on 23.03.18.
//  Copyright © 2018 Oliver-Dudler. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var persons = ["Frieda", "Peter"]
    var hairColor = ["blonde", "brown"]
    var petRace = ["cat", "dog"]
    var petAge = [1,2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.personNameLabel.text = persons[indexPath.row]
        cell.personHairColorLabel.text = hairColor[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
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
            
            //            guard let personNameText = ac.textFields?.first?.text else { return }
            //            guard let personHairColorText = ac.textFields?[1].text else { return }
            
            //            do something with these texts (enter them to cloud and coredata etc.)
            
        }
        
        ac.addAction(cancel)
        ac.addAction(add)
        
        present(ac, animated: true, completion: nil)
    }
    
    
}



