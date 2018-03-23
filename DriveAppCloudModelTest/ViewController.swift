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
}












