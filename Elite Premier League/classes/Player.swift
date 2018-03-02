//
//  Player.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 28/01/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import Foundation
//to allow a ui image to be stored for a player
import UIKit

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
    private var image : UIImage!
    
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
    
    //location of this footballers image on the server
    func imageLocation() -> String{
        return "\(self.team.thisCode)/\(self.photoURL).png"
    }
    
    
    //return player details name and number
    func returnDetails() -> String{
        return "\(self.number). \(self.fName) \(self.lName)"
    }
    
    //getters and setters
    
    var thisNews : String{
        get
        {
            if let new = self.news{
                return new
            }
            return ""
        }
        set
        {
            self.news = newValue
        }
    }
    
    var thisFName : String{
        get
        {
            return self.fName
        }
        set
        {
            self.fName = newValue
        }
    }
    
    var thisTeam : Team{
        get
        {
            return self.team
        }
        set
        {
            self.team = newValue
        }
    }
    
    var thisPlayerId : Int{
        get
        {
            return self.playerId
        }
        set
        {
            self.playerId = newValue
        }
    }
    
    var thisLName : String{
        get
        {
            return lName
        }
        set
        {
            self.lName = newValue
        }
    }
    
    var thisPos : Int{
        get
        {
            return pos
        }
        set
        {
            self.pos = newValue
        }
    }
    
    var thisSaves : Int{
        get
        {
            return saves
        }
        set
        {
            self.saves = newValue
        }
        
    }
    
    var thisCleanSheets : Int{
        get
        {
            return cleanSheets
        }
        set
        {
            self.cleanSheets = newValue
        }
        
    }
    
    var thisGoals : Int{
        get
        {
            return goals
        }
        set
        {
            self.goals = newValue
        }
    }
    
    var thisAssists : Int{
        get
        {
            return assits
        }
        set
        {
            self.assits = newValue
        }
    }
    
    
    var thisYellow : Int{
        get
        {
            return yellowCards
        }
        set
        {
            self.yellowCards = newValue
        }
    }
    var thisRed : Int{
        get
        {
            return redCards
        }
        set
        {
            self.redCards = newValue
        }
    }
    
    //the players photo can be stored when retrieved from the server
    var thisimage: UIImage {
        get {
            return image
        }
        set {
            self.image = newValue
        }
    }
    
}
