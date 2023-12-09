//
//  DataController.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "TripModel")
    
    init(inMemory: Bool = false){
        container.loadPersistentStores{ desc, error in
            if let error = error {
                print("Failed to load data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved.")
        } catch{
            print("Could not save the data.")
        }
    }
    
    func addTrip(name: String, startDate: Date, endDate: Date, context: NSManagedObjectContext) {
        let trip = Trip(context: context)
        trip.id = UUID()
        trip.name = name
        trip.startDate = startDate
        trip.endDate = endDate
        
        save(context: context)
    }
    
    func editTrip(trip: Trip, name: String, startDate: Date, endDate: Date, context: NSManagedObjectContext){
        trip.startDate = startDate
        trip.name = name
        trip.endDate = endDate
        
        save(context: context)
    }
    
    func addPerson(firstName: String, lastName: String, email: String, context: NSManagedObjectContext) {
        let newPerson = Person(context: context)
        newPerson.id = UUID()
        newPerson.firstName = firstName
        newPerson.lastName = lastName
        newPerson.email = email
        
        save(context: context)
    }
    
    func addPersonToTrip(person: Person, trip: Trip, context: NSManagedObjectContext) {
        trip.addToPerson(person)
        save(context: context)
    }

    func addPeopleToTrip(people: Set<Person>, trip: Trip, context: NSManagedObjectContext) {
        for person in people {
            trip.addToPerson(person)
        }
        save(context: context)
    }
}

