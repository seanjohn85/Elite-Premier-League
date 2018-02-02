//
//  Team.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 28/01/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import Foundation


import Foundation

//used to create a team object

public class Team{
    
    //instance varibles
    private var name : String
    private var players : [Player]?
    private var defHome : Int
    private var attHome : Int
    private var home : Int
    private var defAway : Int
    private var attAway : Int
    private var away : Int
    private var fixture : Fixture?
    
    //constructor
    init(name : String, defHome : Int, attHome : Int, home : Int, defAway : Int, attAway : Int, away : Int){
        self.name = name
        self.defHome = defHome
        self.attHome = attHome
        self.home = home
        self.defAway = defAway
        self.attAway = attAway
        self.away = away
    }
    
    //print the teams details for testing
    func printTeam(){
        print("\(self.name) \(self.defHome) \(self.attHome) \(self.home) \(self.defAway) \(self.attAway) \(self.away)")
    }
    
    //add a player to the teams players array
    func addPlayer(player: Player){
        self.players?.append(player)
    }
    
    ///getters and setters
    var thisName : String{
        get
        {
            return name
        }
        set
        {
            self.name = newValue
        }
    }
    
    var thisFixture : Fixture{
        get
        {
            return fixture!
        }
        set
        {
            self.fixture = newValue
        }
    }
}
