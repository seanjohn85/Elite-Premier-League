//
//  Fixture.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 01/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import Foundation

public class Fixture{
    private var homeTeam    : String
    private var awayTeam    : String
    private var date        : String
    private var homeGoals   : Int
    private var awayGoals   : Int
    
    //constructor to create a fixture
    init(homeTeam : String, awayTeam : String, date : String, homeGoals : Int, awayGoals: Int){
        self.homeTeam   = homeTeam
        self.awayTeam   = awayTeam
        self.date       = date
        self.homeGoals  = homeGoals
        self.awayGoals  = awayGoals
    }
    
    ///getters and setters
    var thisHomeTeam : String{
        get
        {
            return homeTeam
        }
        set
        {
            self.homeTeam = newValue
        }
    }
    
    var thisAwayTeam : String{
        get
        {
            return awayTeam
        }
        set
        {
            self.awayTeam = newValue
        }
    }
    
    var thisDate : String{
        get
        {
            return date
        }
        set
        {
            self.date = newValue
        }
    }
    
    var thisHomeGoals : Int{
        get
        {
            return homeGoals
        }
        set
        {
            self.homeGoals = newValue
        }
    }
    
    var thisAwayGoals : Int{
        get
        {
            return awayGoals
        }
        set
        {
            self.awayGoals = newValue
        }
    }
    
}
