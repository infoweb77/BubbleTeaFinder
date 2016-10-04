//
//  PriceInfo+CoreDataProperties.swift
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

extension PriceInfo {

    @NSManaged var priceCategory: String?
    @NSManaged var shop: Shop?

}
