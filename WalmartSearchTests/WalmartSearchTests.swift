//
//  WalmartSearchTests.swift
//  WalmartSearchTests
//
//  Created by Dalton on 5/12/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import XCTest
@testable import WalmartSearch


class WalmartSearchTests: XCTestCase {
    
    let webService:WebService = WebService()
    let baseUrl:String = Constants.Urls.baseUrl
    let key = Constants.Keys.walmartOpenApiKey
    let itemId = 123
    let searchTerm = "term"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    // MARK: - Helpers Tests
    func testHtmlToStringOutput() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let htmlString:String = "<a>This is a string</a>"
        let regularString:String = htmlString.htmlToString
        XCTAssertEqual(regularString, "This is a string")
    }
    
    func testActivityIndicatorManager() {
        let view:UIView = UIView()
        let activityIndicatorManager:ActivityIndicatorManager = ActivityIndicatorManager()
        let activityIndicator:UIActivityIndicatorView = activityIndicatorManager.showLoadingIndicator(view: view)
        
        XCTAssertEqual(activityIndicator.superview, view)
    }
    
    func testFontConstantValue() {
        let font:UIFont = Constants.Fonts.h1!
        XCTAssertEqual(font, UIFont(name: "Bogle-Black", size: 22))
    }
    
    func testSearchUrl() {
        let path = Constants.Paths.searchPath
        let query = "apiKey=\(key)&query=\(searchTerm)&sort=price&order=asc"
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = path
        urlComponents?.query = query
        
        XCTAssertEqual(urlComponents?.url, URL(string:"http://api.walmartlabs.com/v1/search?apiKey=b68mqfez5xhjrqyf9ytv4z96&query=term&sort=price&order=asc"))
    }
    
    func testLookupUrl() {
        let path = "\(Constants.Paths.lookupPath)/\(itemId)"
        let query = "apiKey=\(key)"
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = path
        urlComponents?.query = query
        
        XCTAssertEqual(urlComponents?.url, URL(string:"http://api.walmartlabs.com/v1/items/123?apiKey=b68mqfez5xhjrqyf9ytv4z96"))
    }
    
    func testRecommendationsUrl() {
        let path = Constants.Paths.recommendationsPath
        let query = "apiKey=\(key)&itemId=\(itemId)&order=asc"
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = path
        urlComponents?.query = query
        
        XCTAssertEqual(urlComponents?.url, URL(string:"http://api.walmartlabs.com/v1/nbp?apiKey=b68mqfez5xhjrqyf9ytv4z96&itemId=123&order=asc"))
    }
    
    func testTrendingUrl() {
        let path = Constants.Paths.trendingPath
        let query = "apiKey=\(key)"
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = path
        urlComponents?.query = query
        
        XCTAssertEqual(urlComponents?.url, URL(string:"http://api.walmartlabs.com/v1/trends?apiKey=b68mqfez5xhjrqyf9ytv4z96"))
    }
    
    
    // MARK: - WebService Async Callback Tests
    func testWebServiceGetSearchResultsAsyncCallback() {
        let expectation = XCTestExpectation(description: "WebService gets search results and runs the callback closure")
        webService.getSearchResults(searchTerm: searchTerm) { (searchResults, errorMessage) in
            XCTAssertNotNil(searchResults)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testWebServiceGetRecommendationsAsyncCallback() {
        let expectation = XCTestExpectation(description: "WebService gets recommendations for item id and runs the callback closure")
        webService.getRecommendations(itemId:itemId) { (recommendations, errorMessage) in
            XCTAssertNotNil(recommendations)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testWebServiceGetTrendingItemsAsyncCallback() {
        let expectation = XCTestExpectation(description: "WebService gets trending items and runs the callback closure")
        webService.getTrendingProducts { (trendingItems, errorMessage) in
            XCTAssertNotNil(trendingItems)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20.0)
    }
    
    
    // MARK: - Performance
    func testTrendingAsyncCallbackPerformance() {
        self.measure {
            webService.getTrendingProducts { (trendingItems, errorMessage) in
                XCTAssertNotNil(trendingItems)
            }
        }
    }
    
    func testSearchAsyncCallbackPerformance() {
        self.measure {
            webService.getSearchResults(searchTerm: searchTerm ) { (searchResults, errorMessage) in
                XCTAssertNotNil(searchResults)
            }
        }
    }
    
    func testDetailsAsyncCallbackPerformance() {
        self.measure {
            webService.getProductDetails(itemId: itemId) { (productDetails, errorMessage) in
                XCTAssertNotNil(productDetails)
            }
        }
    }
    
    func testRecommendationsAsyncCallbackPerformance() {
        self.measure {
            webService.getRecommendations(itemId: itemId) { (recommendations, errorMessage) in
                XCTAssertNotNil(recommendations)
            }
        }
    }
    
    
    
    
}
