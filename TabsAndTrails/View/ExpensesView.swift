//
//  ExpensesView.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import Foundation
import SwiftUI

struct ExpensesView: View {
    var trip: Trip
    @Environment(\.managedObjectContext) var managedObjContext

    @FetchRequest var expenses: FetchedResults<Expense>

    init(trip: Trip) {
        self.trip = trip
        self._expenses = FetchRequest<Expense>(
            entity: Expense.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Expense.name, ascending: true)],
            predicate: NSPredicate(format: "trip == %@", trip)
        )
    }

    var body: some View {
        List {
            ForEach(expenses) { expense in
                NavigationLink(destination: ExpenseDetailView(expense: expense, people: trip.peopleArray, customSplit: expense.customSplit, shares: parseShares(expense.shares))) {
                    let userCurrency = UserDefaults.standard.string(forKey: "currency") ?? "USD"
                    let convertedAmount = CurrencyConverter.shared.convertAmount(amount: expense.amount, from: "USD", to: userCurrency)
                    VStack(alignment: .leading, spacing: 5){
                        Text(expense.name ?? "Unnamed")
                        Text("\(expense.person?.firstName ?? "Unknown") \(expense.person?.lastName ?? "") paid \(String(format: "%.2f", convertedAmount))\(userCurrency == "USD" ? "$" : "€")")
                    }
                }
            }
        }
        .navigationTitle("Expenses")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddExpenseView(trip: trip)) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            self.refreshExpenses()
        }
    }

    private func refreshExpenses() {
        expenses.nsPredicate = NSPredicate(format: "trip == %@", trip)
    }

    private func parseShares(_ sharesString: String?) -> [UUID: Double] {
        guard let sharesString = sharesString, let data = sharesString.data(using: .utf8) else { return [:] }
        return (try? JSONDecoder().decode([UUID: Double].self, from: data)) ?? [:]
    }
}
