//
//  StarWarCharacterDataSourceTests.swift
//  SWAPIAppTests
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import XCTest
import RxSwift
@testable import SWAPIApp

class StarWarCharacterDataSourceTests: XCTestCase {
    
    var remoteDataSource: StarWarCharacterDataSource!
    let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        super.setUp()
        remoteDataSource = StarWarCharacterRemoteDataSource()
    }

    override func tearDownWithError() throws {
        super.tearDown()
        remoteDataSource = nil
    }

    func testDataSource() throws {
        
        let fetchCharacterListAPIExpectation = expectation(description: "Character list will be fetched properly")
        
        remoteDataSource
            .fetchCharacters(onPage: 0)
            .subscribe(onNext: { (model) in
                
                            if model.characters.isEmpty == false,
                               model.nextPageNumber == 2,
                               model.previousPageNumber == nil {
                                
                                debugPrint("Total Characters available: \(model.totalCount)")
                                debugPrint("Next Page : \(model.nextPageNumber ?? -1)")
                                debugPrint("Characters listed : \(model.characters.count)")
                                model.characters.forEach { debugPrint($0.name!) }
                                fetchCharacterListAPIExpectation.fulfill()
                                
                            }
                            
                        },
                       onError: nil,
                       onCompleted: nil,
                       onDisposed: nil)
            .disposed(by: disposeBag)
        
        wait(for: [fetchCharacterListAPIExpectation], timeout: 10)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
