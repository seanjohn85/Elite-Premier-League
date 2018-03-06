//
//  Fixture.swift
//  Elite Premier LeagueTests
//
//  Created by JOHN KENNY on 06/03/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import XCTest
@testable import Elite_Premier_League

class FixtureTest: XCTestCase {
    var fix : Fixture?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fix = Fixture(homeTeam : "Test1", awayTeam : "Test2", date : "25/02/18", homeGoals : 2, awayGoals: 2)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHomeTeam() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(((fix?.thisHomeTeam = "Test1") != nil))
        XCTAssertTrue(fix!.thisHomeTeam == "Test1")
    }
    func testAwayTeam() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(((fix?.thisAwayTeam = "Test2") != nil))
        XCTAssertTrue(fix!.thisAwayTeam == "Test2")
    }
    
    func testDate() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(((fix?.thisDate = "25/02/18") != nil))
        XCTAssertTrue(fix!.thisDate == "25/02/18")
    }
    
    func testHomeGoals() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(fix!.thisHomeGoals == 2)
    }
    func testAwayGoals() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(fix!.thisAwayGoals == 2)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
