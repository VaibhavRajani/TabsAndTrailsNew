//
//  Person+CoreDataProperties.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var balance: Double
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastName: String?
    @NSManaged public var expense: NSSet?
    @NSManaged public var trip: NSSet?
    public var wrappedName: String {
        firstName ?? "Unknown Person"
    }
}

// MARK: Generated accessors for expense
extension Person {

    @objc(addExpenseObject:)
    @NSManaged public func addToExpense(_ value: Expense)

    @objc(removeExpenseObject:)
    @NSManaged public func removeFromExpense(_ value: Expense)

    @objc(addExpense:)
    @NSManaged public func addToExpense(_ values: NSSet)

    @objc(removeExpense:)
    @NSManaged public func removeFromExpense(_ values: NSSet)

}

// MARK: Generated accessors for trip
extension Person {

    @objc(addTripObject:)
    @NSManaged public func addToTrip(_ value: Trip)

    @objc(removeTripObject:)
    @NSManaged public func removeFromTrip(_ value: Trip)

    @objc(addTrip:)
    @NSManaged public func addToTrip(_ values: NSSet)

    @objc(removeTrip:)
    @NSManaged public func removeFromTrip(_ values: NSSet)

}

extension Person : Identifiable {

}
