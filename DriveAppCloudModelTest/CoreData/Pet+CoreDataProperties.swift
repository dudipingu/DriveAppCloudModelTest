//
//  Pet+CoreDataProperties.swift
//  DriveAppCloudModelTest
//
//  Created by oliver dudler on 23.03.18.
//  Copyright © 2018 Oliver-Dudler. All rights reserved.
//
//

import Foundation
import CoreData


extension Pet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pet> {
        return NSFetchRequest<Pet>(entityName: "Pet")
    }

    @NSManaged public var age: String?
    @NSManaged public var race: String?
    @NSManaged public var person: Person?

}
