//
//  ExpensesDetailView.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import SwiftUI

struct ExpenseDetailView: View {
    var expense: Expense
    var people: [Person] // List of people involved in the expense
    let userCurrency = UserDefaults.standard.string(forKey: "currency") ?? "USD"
    var customSplit: Bool
    var shares: [UUID: Double]
    
    var body: some View {
        List{
            Section(header: Text("Paid By")) {
                Text("\(expense.person?.firstName ?? "Unknown") \(expense.person?.lastName ?? "")")
            }
            
            Section(header: Text("Amount")) {
                let convertedAmount = CurrencyConverter.shared.convertAmount(amount: expense.amount, from: "USD", to: userCurrency)
                Text("\(String(format: "%.2f", convertedAmount))\(userCurrency == "USD" ? "$" : "€")")
            }
            
            Section(header: Text("Date")) {
                Text(expense.date ?? Date(), formatter: itemFormatter)
            }
            
            Section(header: Text("Shares")) {
                let convertedShares = convertShares(shares: shares, to: userCurrency)
                            ForEach(people, id: \.self) { person in
                                let convertedExpense = CurrencyConverter.shared.convertAmount(amount: expense.amount, from: "USD", to: userCurrency)

                                let share = customSplit ?
                                ExpenseSplitCalculator.calculateCustomShare(expense: expense, person: person, shares: convertedShares, expenseAmount: convertedExpense) :
                                    ExpenseSplitCalculator.calculateRegularShare(expense: expense, person: person, peopleCount: people.count, expenseAmount: convertedExpense)
                                Text(ExpenseSplitCalculator.formatShare(share: share, person: person, isPayer: person.id == expense.person?.id, currencySymbol: (userCurrency == "USD" ? "$" : "€")))
                            }
                        }
            
            Section(header: Text("Receipt")) {
                if let imageData = expense.image, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("No receipt image available")
                }
            }
        }
        .navigationTitle(expense.name ?? "Unknown Expense")
    }
       
    private func formatShare(_ share: Double, for person: Person) -> String {
        let formattedShare = String(format: "%.2f", share) + (userCurrency == "USD" ? "$" : "€")
        if person.id == expense.person?.id {
            return "\(person.firstName ?? "Unknown") gets back \(formattedShare)"
        } else {
            return "\(person.firstName ?? "Unknown") owes \(formattedShare)"
        }
    }
    
    private func convertShares(shares: [UUID: Double], to userCurrency: String) -> [UUID: Double] {
        var convertedShares: [UUID: Double] = [:]
        for (uuid, shareAmount) in shares {
            let convertedShare = CurrencyConverter.shared.convertAmount(amount: shareAmount, from: "USD", to: userCurrency)
            convertedShares[uuid] = convertedShare
        }
        return convertedShares
    }

}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()
