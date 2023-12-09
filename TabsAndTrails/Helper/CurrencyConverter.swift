//
//  CurrencyConverter.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import SwiftUI

struct CurrencyConverter {
    static let shared = CurrencyConverter()
    private let conversionRate = 0.85 // Example: 1 USD = 0.85 EUR

    private init() {}

    func convertAmount(amount: Double, from baseCurrency: String, to targetCurrency: String) -> Double {
        if baseCurrency == "USD" && targetCurrency == "EUR" {
            return amount * conversionRate
        } else if baseCurrency == "EUR" && targetCurrency == "USD" {
            return amount / conversionRate
        }
        return amount // No conversion needed if currencies are the same
    }
}
