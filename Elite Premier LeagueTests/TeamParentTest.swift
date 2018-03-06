//
//  TeamParentTest.swift
//  Elite Premier LeagueTests
//
//  Created by JOHN KENNY on 06/03/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import XCTest
@testable import Elite_Premier_League
import UIKit
import SceneKit
import ARKit


class TeamParentTest: XCTestCase {
     var parent = TeamParent()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        parent.colour = .blue
        
        parent.thisTeam = Team(name : "Team1", code : 1, defHome : 3, attHome : 30, home : 3, defAway : 3, attAway : 30, away : 3)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testColour() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(parent.colour == .blue)
    }
    
    func testChangePlane() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        parent.changeARPlane()
        
    }
 
    func testThisTeam(){
        XCTAssertTrue(parent.thisTeam.thisName == "Team1")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
