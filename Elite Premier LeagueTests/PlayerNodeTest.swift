//
//  PlayerNodeTest.swift
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
import AssetsLibrary

class PlayerNodeTest: XCTestCase {
    
    var pNode = PlayerNode()
    var player1 : Player?
    var team : Team?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        team = Team(name : "Team1", code : 1, defHome : 3, attHome : 30, home : 3, defAway : 3, attAway : 30, away : 3)
        player1 = Player(playerId : 1, team : team!, fName : "Gary", lName : "Neville", pos : 2, goals : 1, assits : 1, saves : 0, number : 2, cleanSheets : 5, ownGoals : 1, penoSaved : 0, penoMissed : 0, photoURL : "nev", yellowCards : 8, redCards : 2)
        player1?.thisimage = #imageLiteral(resourceName: "Man UtdCrest")

        pNode.thisPlayers = [player1!]
        pNode.setup(newColour: .purple)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testColour() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(pNode.colour == .purple)
    }
    
    func testName() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(pNode.name == "playerNode")
    }
    
    func testPlayer() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(pNode.thisPlayers[0].thisFName == player1?.thisFName)
    }
    
    func testImage() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(pNode.thisPlayers[0].thisimage == #imageLiteral(resourceName: "Man UtdCrest"))
    }
    
    func testFunctions() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        pNode.addPlayerToPlane(player: player1!)
        pNode.animate()
        pNode.getPlayerImageFromServer(player: player1!)
        pNode.statNodeGen(name : "n", stat : "w", x : 1, y  : 1)
        pNode.showNews(news : "news")
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
