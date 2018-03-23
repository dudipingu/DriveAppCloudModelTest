//
//  Person+CoreDataProperties.swift
//  DriveAppCloudModelTest
//
//  Created by oliver dudler on 23.03.18.
//  Copyright © 2018 Oliver-Dudler. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var haircolor: String?
    @NSManaged public var name: String?
    @NSManaged public var pet: NSSet?

}

// MARK: Generated accessors for pet
extension Person {

    @objc(addPetObject:)
    @NSManaged public func addToPet(_ value: Pet)

    @objc(removePetObject:)
    @NSManaged public func removeFromPet(_ value: Pet)

    @objc(addPet:)
    @NSManaged public func addToPet(_ values: NSSet)

    @objc(removePet:)
    @NSManaged public func removeFromPet(_ values: NSSet)

}
