//
//  PlayerTest.swift
//  Elite Premier LeagueTests
//
//  Created by JOHN KENNY on 06/03/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import XCTest
@testable import Elite_Premier_League

class PlayerTest: XCTestCase {
    var player1 : Player?
    var player2 : Player?
    var team : Team?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        team = Team(name : "Team1", code : 1, defHome : 3, attHome : 30, home : 3, defAway : 3, attAway : 30, away : 3)
        player1 = Player(playerId : 1, team : team!, fName : "Gary", lName : "Neville", pos : 2, goals : 1, assits : 1, saves : 0, number : 2, cleanSheets : 5, ownGoals : 1, penoSaved : 0, penoMissed : 0, photoURL : "nev", yellowCards : 8, redCards : 2)
        player2 = Player(playerId : 2, team : team!, fName : "Roy", lName : "Keane", pos : 3, goals : 3, assits : 6, saves : 0, number : 16, cleanSheets : 5, ownGoals : 0, penoSaved : 0, penoMissed : 0, photoURL : "roy", yellowCards : 8, redCards : 4)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    //tests the image location function
    func testImageLocation() {
        // This is an example of a functional test case.
        XCTAssertTrue(player1!.imageLocation() == "1/nev.png")
        XCTAssertTrue(player2!.imageLocation() == "1/roy.png")
    }
    
    func testReturnDetails() {
        XCTAssertTrue(player1!.returnDetails() == "2. Gary Neville")
        
        XCTAssertTrue(player2!.returnDetails() == "16. Roy Keane")
    }
    
    func testThisNews(){
        XCTAssertTrue(player1!.thisNews == "")
        player2!.thisNews = "news"
        XCTAssertTrue(player2!.thisNews == "news")
    }
    
    func testThisFName(){
        XCTAssertTrue(player1!.thisFName == "Gary")
        player2!.thisFName = "John"
        XCTAssertTrue(player2!.thisFName == "John")
    }
    
    func testThisLName(){
        XCTAssertTrue(player1!.thisLName == "Neville")
        player2!.thisLName = "Kenny"
        XCTAssertTrue(player2!.thisLName == "Kenny")
    }
    
    func testThisTeam(){
        XCTAssertTrue(player1!.thisTeam.thisName == "Team1")
        player2!.thisTeam.thisName = "Team12"
        XCTAssertTrue(player2!.thisTeam.thisName == "Team12")
    }
    func testThisPlayerId(){
        XCTAssertTrue(player1!.thisPlayerId == 1)
        player2!.thisPlayerId = 3
        XCTAssertTrue(player2!.thisPlayerId == 3)
    }
    func testThisPos(){
        XCTAssertTrue(player1!.thisPos == 2)
        player2!.thisPos = 1
        XCTAssertTrue(player2!.thisPos == 1)
    }
    
    func testThisSaves(){
        XCTAssertTrue(player1!.thisSaves == 0)
        player2!.thisSaves = 5
        XCTAssertTrue(player2!.thisSaves == 5)
    }
    
    func testThisCleanSheets(){
        XCTAssertTrue(player1!.thisCleanSheets == 5)
        player2!.thisCleanSheets = 3
        XCTAssertTrue(player2!.thisCleanSheets == 3)
    }
    
    func testThisGoals(){
        XCTAssertTrue(player1!.thisGoals == 1)
        player2!.thisGoals = 0
        XCTAssertTrue(player2!.thisGoals == 0)
    }
    
    func testThisAssists(){
        XCTAssertTrue(player1!.thisAssists == 1)
        player2!.thisAssists = 0
        XCTAssertTrue(player2!.thisAssists == 0)
    }
    
    func testThisYellow(){
        XCTAssertTrue(player1!.thisYellow == 8)
        player2!.thisYellow = 4
        XCTAssertTrue(player2!.thisYellow == 4)
    }
    
    func testThisRed(){
        XCTAssertTrue(player1!.thisRed == 2)
        player2!.thisRed = 0
        XCTAssertTrue(player2!.thisRed == 0)
    }
    

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
