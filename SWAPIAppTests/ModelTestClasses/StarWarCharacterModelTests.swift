//
//  StarWarCharacterModelTests.swift
//  SWAPIAppTests
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import XCTest
import ObjectMapper

final class StarWarCharacterModelTests: XCTestCase {
    
    let characterJSONString = "{\"name\":\"Luke Skywalker\",\"height\":\"172\",\"mass\":\"77\",\"hair_color\":\"blond\",\"skin_color\":\"fair\",\"eye_color\":\"blue\",\"birth_year\":\"19BBY\",\"gender\":\"male\",\"films\":[\"http://swapi.dev/api/films/1/\",\"http://swapi.dev/api/films/2/\",\"http://swapi.dev/api/films/3/\",\"http://swapi.dev/api/films/6/\"]}"
    
    let optionalJSONString = "{\"name\":\"Luke Skywalker\",\"height\":\"172\",\"mass\":\"77\",\"hair_color\":\"n/a\",\"skin_color\":\"fair\",\"eye_color\":\"blue\",\"birth_year\":\"19BBY\",\"gender\":\"n/a\",\"films\":[\"http://swapi.dev/api/films/1/\",\"http://swapi.dev/api/films/2/\",\"http://swapi.dev/api/films/3/\",\"http://swapi.dev/api/films/6/\"]}"
    
    var characterJSONObject = [String:Any]()

    override func setUpWithError() throws {
        try loadCharacterJSONObject()
    }

    override func tearDownWithError() throws {
        
    }
    
    func loadCharacterJSONObject() throws {
        guard let jsonPath = Bundle.main.path(forResource: "StarWarCharacter", ofType: "json") else {
            return
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe)
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        characterJSONObject = json as! [String:Any]
    }

    func testModelCreationFromLocalResponseJson() throws {
        let model = Mapper<StarWarCharacterModel>().map(JSON: characterJSONObject)
        let modelUnwraped = try XCTUnwrap(model, "Failed to create model")
        XCTAssert(modelUnwraped.name == "Luke Skywalker", "Name mismatch")
        XCTAssert(modelUnwraped.height == "172", "Height mismatch")
        XCTAssert(modelUnwraped.mass == "77", "Mass mismatch")
        XCTAssert(modelUnwraped.hairColor == "blond", "Hair Color mismatch")
        XCTAssert(modelUnwraped.skinColor == "fair", "Skin Color mismatch")
        XCTAssert(modelUnwraped.eyeColor == "blue", "Eye Color mismatch")
        XCTAssert(modelUnwraped.birthYear == "19BBY", "Birth Year mismatch")
        XCTAssert(modelUnwraped.gender == "male", "Gender mismatch")
        XCTAssert(modelUnwraped.filmIds == ["1","2","3","6"], "FilmIds mismatch")
    }
    
    func testModelCreationFromJsonString() throws {
        let model = Mapper<StarWarCharacterModel>().map(JSONString: characterJSONString)
        let modelUnwraped = try XCTUnwrap(model, "Failed to create model")
        XCTAssert(modelUnwraped.name == "Luke Skywalker", "Name mismatch")
        XCTAssert(modelUnwraped.height == "172", "Height mismatch")
        XCTAssert(modelUnwraped.mass == "77", "Mass mismatch")
        XCTAssert(modelUnwraped.hairColor == "blond", "Hair Color mismatch")
        XCTAssert(modelUnwraped.skinColor == "fair", "Skin Color mismatch")
        XCTAssert(modelUnwraped.eyeColor == "blue", "Eye Color mismatch")
        XCTAssert(modelUnwraped.birthYear == "19BBY", "Birth Year mismatch")
        XCTAssert(modelUnwraped.gender == "male", "Gender mismatch")
        XCTAssert(modelUnwraped.filmIds == ["1","2","3","6"], "FilmIds mismatch")
    }
    
    func testModelCreationWithSomeOptionalFields() throws {
        let model = Mapper<StarWarCharacterModel>().map(JSONString: optionalJSONString)
        let modelUnwraped = try XCTUnwrap(model, "Failed to create model")
        XCTAssert(modelUnwraped.name == "Luke Skywalker", "Name mismatch")
        XCTAssert(modelUnwraped.height == "172", "Height mismatch")
        XCTAssert(modelUnwraped.mass == "77", "Mass mismatch")
        XCTAssert(modelUnwraped.hairColor == nil, "Hair Color not nil")
        XCTAssert(modelUnwraped.skinColor == "fair", "Skin Color mismatch")
        XCTAssert(modelUnwraped.eyeColor == "blue", "Eye Color mismatch")
        XCTAssert(modelUnwraped.birthYear == "19BBY", "Birth Year mismatch")
        XCTAssert(modelUnwraped.gender == nil, "Gender not nil")
        XCTAssert(modelUnwraped.filmIds == ["1","2","3","6"], "FilmIds mismatch")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
