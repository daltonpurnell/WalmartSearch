//
//  WalmartSearchUITests.swift
//  WalmartSearchUITests
//
//  Created by Dalton on 5/12/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import XCTest

class WalmartSearchUITests: XCTestCase {
    let app = XCUIApplication()

        
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
    
    func testSearchBarText() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let searchSearchField = app.searchFields["Search"]

        searchSearchField.tap()

        let textToType = "Thing"

        for c in textToType {
            searchSearchField.typeText("\(c)")
        }
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let searchBarText = searchSearchField.value as! String

        XCTAssertEqual(searchBarText, "Thing")
    }
    
    func testTableViewEmptyState() {
        let tableView = app.tables["No search results to display"].staticTexts["No search results to display"]
        
        XCTAssertEqual(tableView.cells.count, 0)
    }
    
}
