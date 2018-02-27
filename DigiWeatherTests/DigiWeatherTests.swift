//
//  DigiWeatherTests.swift
//  DigiWeatherTests
//
//  Created by Ehsan Askari on 2/22/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import XCTest
@testable import DigiWeather

class DigiWeatherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let w = Weather()
        XCTAssertEqual(w.locationName, "")
        XCTAssertEqual(w.dailyArray.count, 0)
        
        let lr = LocationRealm()
        lr.id = lr.generateUUID()
        XCTAssertNotEqual(lr.id, "")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
