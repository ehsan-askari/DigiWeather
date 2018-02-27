//
//  DigiWeatherUITests.swift
//  DigiWeatherUITests
//
//  Created by Ehsan Askari on 2/22/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import XCTest

class DigiWeatherUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        let app = XCUIApplication()
        app.buttons[""].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons[""].tap()
        app.searchFields["Enter location name..."].typeText("Sari")
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Sari Aghaj, Syria"]/*[[".cells.staticTexts[\"Sari Aghaj, Syria\"]",".staticTexts[\"Sari Aghaj, Syria\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Sari Bahlol, Pakistan"]/*[[".cells.staticTexts[\"Sari Bahlol, Pakistan\"]",".staticTexts[\"Sari Bahlol, Pakistan\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Sari Bakhsh, Iran"]/*[[".cells.staticTexts[\"Sari Bakhsh, Iran\"]",".staticTexts[\"Sari Bakhsh, Iran\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery.tables/*@START_MENU_TOKEN@*/.staticTexts["Sari Bakhsh"]/*[[".cells.staticTexts[\"Sari Bakhsh\"]",".staticTexts[\"Sari Bakhsh\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        
    }
    
    func testExample1() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCUIDevice.shared.orientation = .portrait
        
        let app = XCUIApplication()
        app.children(matching: .window).element(boundBy: 4).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 2).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).tap()
        XCUIDevice.shared.orientation = .portrait
        app.scrollViews.otherElements.tables/*@START_MENU_TOKEN@*/.staticTexts["Tehran"]/*[[".cells.staticTexts[\"Tehran\"]",".staticTexts[\"Tehran\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .image).element.tap()
        
        
        
    }
    
}
