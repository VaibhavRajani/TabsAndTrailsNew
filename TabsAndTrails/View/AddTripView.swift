//
//  AddTripView.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import SwiftUI

struct AddTripView: View {
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
    @State private var fullName = ""
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showingSelectPersonView = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.lastName, ascending: true)],
        animation: .default)
    
    private var persons: FetchedResults<Person>
    var body: some View {
        Form {
            Section(header: Text("Trip Details")) {
                Text("Trip Name")
                    .foregroundColor(.gray)
                    .font(.caption)
                TextField("Trip name", text: $name)
                
                Text("Trip Duration")
                    .foregroundColor(.gray)
                    .font(.caption)
                
                VStack(alignment: .leading) {
                    Text("FROM:")
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    
                    Text("TO:")
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                
                
                
            }
            
            if !selectedPeople.isEmpty {
                Section(header: Text("People")) {
                    ForEach(persons.filter { selectedPeople.contains($0.id!) }, id: \.self) { person in
                        Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                    }
                }
            }

            Section(header: Text("Add A Person")) {
                Button(action: { showingSelectPersonView = true }) {
                    HStack {
                        Text(selectedPerson != nil ? "\(selectedPerson!.firstName ?? "") \(selectedPerson!.lastName ?? "")" : "Select Person")
                        Spacer()
                    }
                }
                .sheet(isPresented: $showingSelectPersonView) {
                    SelectPersonView(selectedPerson: $selectedPerson, context: .trip, people: persons.filter { !selectedPeople.contains($0.id!) })
                }

                if let person = selectedPerson {
                    HStack {
                        Spacer()
                        Button("Add Person") {
                            if !selectedPeople.contains(person.id!) {
                                selectedPeople.insert(person.id!)
                                addPersonToTrip(person: person)
                                selectedPerson = nil
                            } else{
                                print("Person already exists in the trip.")
                            }
                        }
                        .buttonStyle(BlueButtonStyle())
                        Spacer()
                    }
                }
            }
            
            Section(header: Text("Add New Person")) {
                TextField("First Name Last Name", text: $fullName)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
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

            }


            
            HStack{
                Spacer()
                Button("Add Trip") {
                    DataController().save(context: managedObjContext)
                    dismiss()
                }
                .buttonStyle(BlueButtonStyle())
                Spacer()
            }
        }
    }
    
    private func addPersonToTrip(person: Person) {
        if currentTrip == nil {
            currentTrip = Trip(context: managedObjContext)
            currentTrip!.id = UUID()
            currentTrip!.name = name
            currentTrip!.startDate = startDate
            currentTrip!.endDate = endDate
        }
        currentTrip!.addToPerson(person)
        selectedPeople.insert(person.id!)
    }

}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View{
        AddTripView()
    }
}
