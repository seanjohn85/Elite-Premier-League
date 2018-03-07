//
//  TeamTest.swift
//  Elite Premier LeagueTests
//
//  Created by JOHN KENNY on 06/03/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import XCTest
@testable import Elite_Premier_League


class TeamTest: XCTestCase {
    var player1 : Player?
    var player2 : Player?
    var teams1 : Team?
    var teams2 : Team?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        teams1 = Team(name : "Team1", code : 1, defHome : 3, attHome : 30, home : 3, defAway : 3, attAway : 30, away : 3)
        teams2 = Team(name : "Team2", code : 2, defHome : 3, attHome : 3, home : 3, defAway : 3, attAway : 3, away : 3)
        player1 = Player(playerId : 1, team : teams1!, fName : "Gary", lName : "Neville", pos : 2, goals : 1, assits : 1, saves : 0, number : 2, cleanSheets : 5, ownGoals : 1, penoSaved : 0, penoMissed : 0, photoURL : "nev", yellowCards : 8, redCards : 2)
        player2 = Player(playerId : 2, team : teams1!, fName : "Roy", lName : "Keane", pos : 3, goals : 3, assits : 6, saves : 0, number : 16, cleanSheets : 5, ownGoals : 0, penoSaved : 0, penoMissed : 0, photoURL : "roy", yellowCards : 8, redCards : 4)
        teams1?.thisPlayers = [player1!, player2!]
        
        teams1?.printTeam()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    //test the getable vars from a team
    func testTeamCodes() {
        teams2?.thisCode = 4
        XCTAssertTrue(teams1?.thisCode == 1)
        XCTAssertTrue(teams2?.thisCode == 4)
    }
    
    func testTeamName() {
        teams1?.thisName = "new"
        XCTAssertTrue(teams1?.thisName == "new")
        XCTAssertTrue(teams2?.thisName == "Team2")
    }
    
    func testAttack() {
        teams2?.thisAttHome = 0
        XCTAssertTrue(teams1!.thisAttHome > teams2!.thisAttHome)
    }
    
    func testFixture(){
        let fix = Fixture(homeTeam : "Test1", awayTeam : "Test2", date : "25/02/18", homeGoals : 2, awayGoals: 2)
        teams1?.thisFixture = fix
        XCTAssertTrue(teams1!.thisFixture.thisHomeTeam == fix.thisHomeTeam)
    }
    
    func testPlayers(){
        XCTAssertTrue(teams1!.thisPlayers[0].thisFName == player1!.thisFName)
        XCTAssertTrue(teams1!.thisPlayers[1].thisFName == player2!.thisFName)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
