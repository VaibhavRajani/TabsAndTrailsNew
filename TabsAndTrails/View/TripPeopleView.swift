//
//  TripPeopleView.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import Foundation
import SwiftUI

struct TripPeopleView: View {
    var trip: Trip
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedPerson: Person?
    @State private var selectedPeople = Set<UUID>()
    @State private var currentTrip: Trip?
    @State private var email = ""
    @State private var fullName = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.lastName, ascending: true)],
        animation: .default)
    private var persons: FetchedResults<Person>
    
    
    var body: some View {
        Form {
            Section(header: Text("People")) {
                if case let peopleArray = trip.peopleArray {
                    ForEach(peopleArray, id: \.self) { person in
                        Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                    }
                }
                
            }
            
            Section(header: Text("Add A Person")) {
                NavigationLink(destination: SelectPersonView(selectedPerson: $selectedPerson, context: .trip, people: persons.filter { !trip.peopleArray.contains($0) })) {
                    HStack{
                        Text("Name: ")
                        Spacer()
                        Text("\(selectedPerson?.firstName ?? "") \(selectedPerson?.lastName ?? "")")
                            .foregroundStyle(.gray)
                    }
                }
                HStack{
                    Spacer()
                    Button("Add Person") {
                        let people = persons.filter { !trip.peopleArray.contains($0) }
                        print(people)
                        if let person = selectedPerson {
                            if !trip.peopleArray.contains(where: { $0.id == person.id }) {
                                addPersonToTrip(person: person)
                                selectedPerson = nil
                            } else {
                                print("Person already exists in the trip.")
                            }
                        }
                    }
                    .buttonStyle(BlueButtonStyle())
                    Spacer()
                }
            }
            
            Section(header: Text("Add New Person")) {
                TextField("First Name Last Name", text: $fullName)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                HStack{
                    Spacer()
                    Button("Add New Person") {
                        let names = fullName.split(separator: " ").map(String.init)
                        let firstName = names.first ?? ""
                        let lastName = names.dropFirst().joined(separator: " ")

                        if firstName.isEmpty || lastName.isEmpty || email.isEmpty {
                            alertMessage = "All fields must be filled."
                            showAlert = true
                        } else {
                            DataController().addPerson(firstName: firstName, lastName: lastName, email: email, context: managedObjContext)
                            fullName = ""
                            email = ""
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .buttonStyle(BlueButtonStyle())
                    Spacer()
                }
            }


            
            Section{
                HStack{
                    Spacer()
                    Button("Confirm Changes") {
                        DataController().save(context: managedObjContext)
                        dismiss()
                    }
                    .buttonStyle(BlueButtonStyle())
                    Spacer()
                }
            }
            if !selectedPeople.isEmpty {
                Section(header: Text("People Added to Trip")) {
                    ForEach(persons.filter { selectedPeople.contains($0.id!) }, id: \.self) { person in
                        Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                    }
                }
            }
            
            BlueNavigationLink(destination: ExpensesView(trip: trip)) {
                Text("Expenses")
            }
            
            BlueNavigationLink(destination: SettleUpView(trip: trip)) {
                Text("Settle Up")
            }
        }
        .navigationTitle(trip.name!)
        .onAppear{
            loadBalances()
        }
    }
    private func addPersonToTrip(person: Person) {
        if trip != nil {
            DataController().addPersonToTrip(person: selectedPerson!, trip: trip, context: managedObjContext)
            if trip.balances[person.id!] == nil {
                trip.balances[person.id!] = 0
            }
        } else {
            print("Error Adding to Trip")
        }
    }
    
    func loadBalances() {
        if let savedBalances = UserDefaults.standard.object(forKey: "balances_\(String(describing: trip.id))") as? Data {
            if let decodedBalances = try? JSONDecoder().decode([UUID: Double].self, from: savedBalances) {
                trip.balances = decodedBalances
            }
        }
    }
}

#Preview {
    ContentView()
}
