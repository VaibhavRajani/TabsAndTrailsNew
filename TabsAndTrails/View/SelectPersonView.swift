//
//  SelectPersonView.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import Foundation
import SwiftUI

enum SelectPersonContext {
    case trip
    case expense
}

struct SelectPersonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var selectedPerson: Person?
    var context: SelectPersonContext
    var people: [Person]

    var body: some View {
        List(people, id: \.self) { person in
            Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                .onTapGesture {
                    self.selectedPerson = person
                    self.presentationMode.wrappedValue.dismiss()
                }
        }
    }
}


