//
//  Player.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 28/01/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import Foundation

//player class used to create player objects
//player objects will be generated using the json response from the server


public class Player{
    
    //instance varibles belonging to a player object
    private var playerId : Int
    private var team : Team
    private var fName : String
    private var lName : String
    private var pos : Int
    private var goals : Int
    private var assits : Int
    private var saves : Int
    private var number : Int
    private var cleanSheets : Int
    private var ownGoals : Int
    private var penoSaved : Int
    private var penoMissed : Int
    private var photoURL : String
    private var yellowCards : Int
    private var redCards : Int
    private var news : String?
    
    ///constructor for player objects
    init (playerId : Int, team : Team, fName : String, lName : String, pos : Int, goals : Int, assits : Int, saves : Int, number : Int, cleanSheets : Int, ownGoals : Int, penoSaved : Int, penoMissed : Int, photoURL : String, yellowCards : Int, redCards : Int){
        self.playerId = playerId
        self.team = team
        self.fName = fName
        self.lName = lName
        self.pos = pos
        self.goals = goals
        self.assits = assits
        self.saves = saves
        self.number = number
        self.cleanSheets = cleanSheets
        self.ownGoals = ownGoals
        self.penoSaved = penoSaved
        self.penoMissed = penoMissed
        self.photoURL = photoURL
        self.yellowCards = yellowCards
        self.redCards = redCards

    }
    
    func imageLocation() -> String{
        return "\(self.team.thisCode)\(self.photoURL).png"
    }
    
}
