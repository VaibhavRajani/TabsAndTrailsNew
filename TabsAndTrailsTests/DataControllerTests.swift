//
//  DataControllerTests.swift
//  TabsAndTrailsTests
//
//  Created by Vaibhav Rajani on 12/10/23.
//

import XCTest
@testable import TabsAndTrails
import CoreData

class DataControllerTests: XCTestCase {
    
    var dataController: DataController!
    var mockManagedObjectContext: NSManagedObjectContext!
    var testTrip: Trip!
    var testPerson: Person!
    
    override func setUpWithError() throws {
        super.setUp()
        // Initialize the DataController with an in-memory store for testing
        dataController = DataController(inMemory: true)
        mockManagedObjectContext = dataController.container.viewContext
        
        testTrip = Trip(context: mockManagedObjectContext)
        testTrip.id = UUID()
        testTrip.name = "Test Trip"
        
        testPerson = Person(context: mockManagedObjectContext)
        testPerson.id = UUID()
        testPerson.firstName = "John"
        testPerson.lastName = "Doe"
        
        try mockManagedObjectContext.save()
    }
    
    override func tearDownWithError() throws {
        dataController = nil
        mockManagedObjectContext = nil
        testTrip = nil
        testPerson = nil
        super.tearDown()
    }
    
    func testAddPerson() throws {
        // Define test data
        let firstName = "John"
        let lastName = "Doe"
        let email = "johndoe@example.com"
        
        // Perform the addPerson action
        dataController.addPerson(firstName: firstName, lastName: lastName, email: email, context: mockManagedObjectContext)
        
        // Fetch the newly added person from the context
        let fetchRequest = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "firstName == %@ AND lastName == %@ AND email == %@", firstName, lastName, email)
        let results = try mockManagedObjectContext.fetch(fetchRequest)
        
        // Assert that the person was added successfully
        XCTAssertEqual(results.count, 1, "Should be exactly one person with the specified details")
        let addedPerson = results.first
        XCTAssertEqual(addedPerson?.firstName, firstName, "First name should match")
        XCTAssertEqual(addedPerson?.lastName, lastName, "Last name should match")
        XCTAssertEqual(addedPerson?.email, email, "Email should match")
    }
    
    func testAddPersonToTrip() throws {
        // Add the person to the trip
        dataController.addPersonToTrip(person: testPerson, trip: testTrip, context: mockManagedObjectContext)
        
        // Assert that the person was added to the trip
        let fetchRequest = Trip.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", testTrip.id! as CVarArg)
        let fetchedTrips = try mockManagedObjectContext.fetch(fetchRequest)
        let fetchedTrip = fetchedTrips.first
        
        XCTAssertNotNil(fetchedTrip, "The trip should be fetched")
        XCTAssertTrue(fetchedTrip?.peopleArray.contains(testPerson) ?? false, "The trip should contain the added person")
    }
    
}
