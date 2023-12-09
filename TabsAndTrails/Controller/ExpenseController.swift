//
//  ExpenseController.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import SwiftUI
import Foundation
import CoreData

class ExpenseController {
    static func addExpense(to trip: Trip, name: String, amount: Double, paidBy: Person, customSplit: Bool, shares: [UUID: Double], imageData: Data?, context: NSManagedObjectContext) {
        let amountDouble = amount
        let payerID = paidBy.id
        if trip.balances.isEmpty {
            trip.peopleArray.forEach { person in
                trip.balances[person.id!] = 0
            }
        }
        let newExpense = Expense(context: context)
        newExpense.id = UUID()
        newExpense.name = name
        newExpense.amount = amountDouble
        newExpense.person = paidBy
        newExpense.customSplit = false
        newExpense.date = Date()
        trip.addToExpense(newExpense)
        
        let splitAmount = amountDouble / Double(trip.peopleArray.count)
        for person in trip.peopleArray {
            if person.id == payerID {
                trip.balances[payerID!, default: 0] += amountDouble - splitAmount
            } else {
                trip.balances[person.id!, default: 0] -= splitAmount
            }
        }
        DataController().save(context: context)
    }
    
    static func addCustomSplitExpense(to trip: Trip, name: String, amount: Double, paidBy: Person, customSplit: Bool, shares: [UUID: Double], imageData: Data?, context: NSManagedObjectContext) {
        let amountDouble = amount
        let payerID = paidBy.id
        if trip.balances.isEmpty {
            trip.peopleArray.forEach { person in
                trip.balances[person.id!] = 0
            }
        }
        
        let newExpense = Expense(context: context)
        newExpense.shares = encodeShares(shares)
        newExpense.id = UUID()
        newExpense.name = name
        newExpense.amount = amountDouble
        newExpense.person = paidBy
        newExpense.customSplit = true
        newExpense.date = Date()
        newExpense.image = imageData
        trip.addToExpense(newExpense)
        
        let customSplitTotal = shares.values.reduce(0, +)
        guard customSplitTotal == amountDouble else {
            print("Custom split amounts do not total up to the expense amount.")
            return
        }
        
        for person in trip.peopleArray {
            if let share = shares[person.id!] {
                if person.id == payerID {
                    trip.balances[payerID!, default: 0] += amountDouble - share
                } else {
                    trip.balances[person.id!, default: 0] -= share
                }
            }
        }
        DataController().save(context: context)
    }
    
    private static func encodeShares(_ shares: [UUID: Double]) -> String? {
        guard let data = try? JSONEncoder().encode(shares),
              let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
    
    private static func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
