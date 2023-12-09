//
//  SettingsView.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedCurrency: String = UserDefaults.standard.string(forKey: "currency") ?? "USD"
    
    var body: some View {
        Form {
            Section(header: Text("Currency")) {
                Picker("Select Currency", selection: $selectedCurrency) {
                    Text("USD").tag("USD")
                    Text("EUR").tag("EUR")
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedCurrency) { newValue in
                    UserDefaults.standard.set(newValue, forKey: "currency")
                }
            }
        }
        .navigationTitle("Settings")
    }
}
