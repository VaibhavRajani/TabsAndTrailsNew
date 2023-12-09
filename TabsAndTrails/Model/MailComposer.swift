//
//  MailComposer.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import Foundation

class MailComposer {
    static func createMailBody(for trip: Trip) -> String {
        var body = "Trip Name: \(trip.name ?? "Trip")\n\n"
        for person in trip.peopleArray {
            let transactions = SettlementCalculator.settleUp(trip: trip, for: person)
            for transaction in transactions {
                body += "\(person.firstName!)" + ": " + "\(transaction)\n"
            }
        }
        return body
    }
}
