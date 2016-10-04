//
//  Shop+CoreDataProperties.swift
//  BubbleTeaFinder
//
//  Created by alex on 16/09/16.
//  Copyright © 2016 alex. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Shop {

    @NSManaged var favorite: NSNumber?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var specialCount: NSNumber?
    @NSManaged var location: Location?
    @NSManaged var category: Category?
    @NSManaged var priceInfo: PriceInfo?
    @NSManaged var stats: Stats?

}
