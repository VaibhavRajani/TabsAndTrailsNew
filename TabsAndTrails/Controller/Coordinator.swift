//
//  Coordinator.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import Foundation
import SwiftUI
import MessageUI

class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    @Binding var presentationMode: PresentationMode
    var trip: Trip

    init(presentationMode: Binding<PresentationMode>, trip: Trip) {
        _presentationMode = presentationMode
        self.trip = trip
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        $presentationMode.wrappedValue.dismiss()
    }
    
    private func getEmailAddresses() -> [String] {
         trip.peopleArray.compactMap { $0.email }
     }
    
    func composeMail() -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        let subject = "Reminder from Budgetly"
        let messageBody = MailComposer.createMailBody(for: trip)
        mailVC.setSubject(subject)
        mailVC.setMessageBody(messageBody, isHTML: false)
        let recipients = getEmailAddresses()
        mailVC.setToRecipients(recipients)
        return mailVC
    }
}
