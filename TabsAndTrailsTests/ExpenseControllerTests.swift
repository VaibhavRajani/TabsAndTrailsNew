//
//  ExpenseTests.swift
//  TabsAndTrailsTests
//
//  Created by Vaibhav Rajani on 12/10/23.
//

import XCTest
@testable import TabsAndTrails
import CoreData

class ExpenseControllerTests: XCTestCase {

    var dataController: DataController!
    var mockManagedObjectContext: NSManagedObjectContext!
    var testTrip: Trip!
    var testPerson: Person!

    override func setUpWithError() throws {
        super.setUp()
        // Initialize the DataController with an in-memory store for testing
        dataController = DataController(inMemory: true)
        mockManagedObjectContext = dataController.container.viewContext

        // Setup a test trip and a test person for the expense
        testTrip = Trip(context: mockManagedObjectContext)
        testTrip.id = UUID()
        testTrip.name = "Test Trip"

        testPerson = Person(context: mockManagedObjectContext)
        testPerson.id = UUID()
        testPerson.firstName = "John"
        testPerson.lastName = "Doe"
        testTrip.addToPerson(testPerson)
        
        try mockManagedObjectContext.save()
    }

    override func tearDownWithError() throws {
        dataController = nil
        mockManagedObjectContext = nil
        testTrip = nil
        testPerson = nil
        super.tearDown()
    }

    func testAddExpense() throws {
        // Expense details
        let expenseName = "Lunch"
        let amount = 100.0

        // Add expense to the trip
        ExpenseController.addExpense(to: testTrip, name: expenseName, amount: amount, paidBy: testPerson, customSplit: false, shares: [:], imageData: nil, context: mockManagedObjectContext)

        // Assert that the expense was added
        let fetchRequest = Expense.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", expenseName)
        let results = try mockManagedObjectContext.fetch(fetchRequest)

        XCTAssertEqual(results.count, 1, "Should be exactly one expense with the specified name")
        let addedExpense = results.first
        XCTAssertEqual(addedExpense?.name, expenseName, "Expense name should match")
        XCTAssertEqual(addedExpense?.amount, amount, "Expense amount should match")
        XCTAssertEqual(addedExpense?.person, testPerson, "Payer should match")
    }

    // Additional test cases can be added for custom split expenses, invalid data scenarios, etc.
}
