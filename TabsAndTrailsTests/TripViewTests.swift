//
//  TabsAndTrailsTests.swift
//  TabsAndTrailsTests
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import XCTest
@testable import TabsAndTrails
import CoreData

final class TabsAndTrailsTests: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
       
    func testAddTrip() {
        let dataController = DataController(inMemory: true)
        let tripName = "Test Trip"
        let startDate = Date()
        let endDate = Date().addingTimeInterval(24 * 60 * 60) // 1 day later
        
        dataController.addTrip(name: tripName, startDate: startDate, endDate: endDate, context: dataController.container.viewContext)
        
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        let trips = try? dataController.container.viewContext.fetch(fetchRequest)
        
        XCTAssertEqual(trips?.count, 1)
        XCTAssertEqual(trips?.first?.name, tripName)
        XCTAssertEqual(trips?.first?.startDate, startDate)
        XCTAssertEqual(trips?.first?.endDate, endDate)
    }
    
    
    
}
