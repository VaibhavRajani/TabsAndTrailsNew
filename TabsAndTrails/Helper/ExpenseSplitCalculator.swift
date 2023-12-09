//
//  ExpenseSplitCalculator.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import SwiftUI

struct ExpenseSplitCalculator {
    static func calculateRegularShare(expense: Expense, person: Person, peopleCount: Int, expenseAmount: Double) -> Double {
        print("Expense Amount:", expenseAmount)
        print("People Count: ", peopleCount)
        let splitAmount = expenseAmount / Double(peopleCount)
        print(splitAmount)

        if person.id == expense.person?.id {
            print("Payer gets ", (expenseAmount - splitAmount))

            return expenseAmount - splitAmount
        } else {
            return splitAmount
        }
    }

    static func calculateCustomShare(expense: Expense, person: Person, shares: [UUID: Double], expenseAmount: Double) -> Double {
        guard let personShare = shares[person.id!] else { return 0 }
        let totalAmount = expenseAmount
        let payer = expense.person
        print(personShare)
        if person.id == payer?.id {
            let totalShares = shares.values.reduce(0, +)
            return totalAmount - personShare
        } else {
            return personShare
        }
    }

    static func formatShare(share: Double, person: Person, isPayer: Bool, currencySymbol: String) -> String {
        let formattedShare = String(format: "%.2f", share) + currencySymbol
        if isPayer {
            return "\(person.firstName ?? "Unknown") gets back \(formattedShare)"
        } else {
            return "\(person.firstName ?? "Unknown") owes \(formattedShare)"
        }
    }
}
