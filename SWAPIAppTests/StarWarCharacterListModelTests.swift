//
//  StarWarCharacterListModelTests.swift
//  SWAPIAppTests
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import XCTest
import ObjectMapper

class StarWarCharacterListModelTests: XCTestCase {
    
    var characterListJSONObject = [String:Any]()

    override func setUpWithError() throws {
        try loadCharacterListJSONObject()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func loadCharacterListJSONObject() throws {
        guard let jsonPath = Bundle.main.path(forResource: "StarWarCharacterListPage1", ofType: "json") else {
            return
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe)
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        characterListJSONObject = json as! [String:Any]
    }

    func testModelCreationFromLocalResponseJson() throws {
        let model = Mapper<StarWarCharacterListModel>().map(JSON: characterListJSONObject)
        let modelUnwraped = try XCTUnwrap(model, "Failed to create model")
        XCTAssert(modelUnwraped.totalCount == 82, "Total count of characters is not equal to 82")
        XCTAssert(modelUnwraped.nextPageNumber == 2, "Next Page Number is not present")
        XCTAssert(modelUnwraped.previousPageNumber == nil, "Previous Page Number is present")
        XCTAssert(modelUnwraped.characters.count == 10, "Character count mismatch")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
