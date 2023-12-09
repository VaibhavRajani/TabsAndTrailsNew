//
//  SettleUpView.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import Foundation
import SwiftUI
import MessageUI

struct SettleUpView: View {
    var trip: Trip
    @State private var showMailView = false
    @State var mailMessageBody = ""
    @State var subject = ""
    
    var body: some View {
        VStack{
            List {
                ForEach(trip.peopleArray, id: \.self) { person in
                    Section(header: Text(person.firstName ?? "Unknown")) {
                        ForEach(SettlementCalculator.settleUp(trip: trip, for: person), id: \.self) { transaction in
                            Text(transaction)
                        }
                    }
                }
            }
            Spacer()
            
            Button("Remind People") {
                if MFMailComposeViewController.canSendMail() {
                    showMailView = true
                } else {
                    print("Device not supported.")
                }
            }
            
            .padding()
        }
        .navigationTitle("Settle Up!")
        .sheet(isPresented: $showMailView) {
            MailView(trip: trip)
        }
    }
}
