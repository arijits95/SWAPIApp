//
//  StartWarFilmModelTests.swift
//  SWAPIAppTests
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import XCTest
import ObjectMapper

class StartWarFilmModelTests: XCTestCase {
    
    var filmJSONObject = [String:Any]()

    override func setUpWithError() throws {
        try loadFilmJSONObject()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func loadFilmJSONObject() throws {
        guard let jsonPath = Bundle.main.path(forResource: "StarWarFilm", ofType: "json") else {
            return
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe)
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        filmJSONObject = json as! [String:Any]
        debugPrint(filmJSONObject)
    }

    func testModelCreationFromLocalResponseJson() throws {
        let model = Mapper<StarWarFilmModel>().map(JSON: filmJSONObject)
        let modelUnwraped = try XCTUnwrap(model, "Failed to create model")
        XCTAssert(modelUnwraped.title == "A New Hope", "Title mismatch")
        XCTAssert(modelUnwraped.openingCrawl != nil, "Opening Crawl is nil")
        XCTAssert(modelUnwraped.openingCrawlWordCount == 83, "Opening Crawl word count mismatch")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
