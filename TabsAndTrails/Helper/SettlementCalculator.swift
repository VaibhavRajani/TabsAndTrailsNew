//
//  SettlementCalculator.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import Foundation

class SettlementCalculator {
    static func settleUp(trip: Trip, for person: Person) -> [String] {
        var transactions = [String]()
        let userCurrency = UserDefaults.standard.string(forKey: "currency") ?? "USD"
        let personBalance = trip.balances[person.id!] ?? 0
        let convertedBalance = convertAmount(amount: personBalance, from: "USD", to: userCurrency)
        
        if convertedBalance < 0 {
            for creditor in trip.peopleArray {
                let creditorBalance = trip.balances[creditor.id!] ?? 0
                let convertedCreditorBalance = convertAmount(amount: creditorBalance, from: "USD", to: userCurrency)
                if convertedCreditorBalance > 0 {
                    let amount = min(-convertedBalance, convertedCreditorBalance)
                    if amount > 0 {
                        transactions.append("Owes \(creditor.firstName ?? "") \(String(format: "%.2f", amount))\(userCurrency == "USD" ? "$" : "€")")
                    }
                }
            }
        } else if convertedBalance > 0 {
            transactions.append("Gets back \(String(format: "%.2f", convertedBalance))\(userCurrency == "USD" ? "$" : "€")")
        } else {
            transactions.append("Balanced")
        }
        
        return transactions
    }
    
    
}

func convertAmount(amount: Double, from baseCurrency: String, to targetCurrency: String) -> Double {
    let conversionRate = 0.85 // 1 USD = 0.85 EUR
    if baseCurrency == "USD" && targetCurrency == "EUR" {
        return amount * conversionRate
    } else if baseCurrency == "EUR" && targetCurrency == "USD" {
        return amount / conversionRate
    }
    return amount // No conversion needed if currencies are the same
}

