//
//  Expense+CoreDataProperties.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var customSplit: Bool
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var shares: String?
    @NSManaged public var person: Person?
    @NSManaged public var trip: Trip?

}

extension Expense : Identifiable {

}
