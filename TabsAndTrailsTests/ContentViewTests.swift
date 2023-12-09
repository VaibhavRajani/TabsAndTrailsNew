//
//  ContentViewTests.swift
//  TabsAndTrailsTests
//
//  Created by Vaibhav Rajani on 12/10/23.
//

import XCTest
@testable import TabsAndTrails
import CoreData

class ContentViewTests: XCTestCase {

    var dataController: DataController!
    var mockManagedObjectContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        super.setUp()
        // Initialize the DataController with an in-memory store for testing
        dataController = DataController(inMemory: true)
        mockManagedObjectContext = dataController.container.viewContext

        // Add a sample trip for testing deletion
        let trip = Trip(context: mockManagedObjectContext)
        trip.id = UUID()
        trip.name = "Sample Trip"
        trip.startDate = Date()
        trip.endDate = Date()
        try mockManagedObjectContext.save()
    }

    override func tearDownWithError() throws {
        dataController = nil
        mockManagedObjectContext = nil
        super.tearDown()
    }

    func testDeleteTrip() throws {
        // Fetch the trip to be deleted
        let fetchRequest = Trip.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", "Sample Trip")
        var fetchedTrips = try mockManagedObjectContext.fetch(fetchRequest)
        XCTAssertEqual(fetchedTrips.count, 1, "Should start with one trip")

        // Delete the trip
        let tripToDelete = fetchedTrips[0]
        mockManagedObjectContext.delete(tripToDelete)
        try mockManagedObjectContext.save()

        // Fetch again to check if the trip is deleted
        fetchedTrips = try mockManagedObjectContext.fetch(fetchRequest)
        XCTAssertEqual(fetchedTrips.count, 0, "Trip should be deleted")
    }

    // ... other test cases ...
}
