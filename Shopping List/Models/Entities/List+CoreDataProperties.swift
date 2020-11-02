//
//  List+CoreDataProperties.swift
//
//  Created by Dmitry Vorozhbicki on 01/11/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var archivedDate: Date?
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension List {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
