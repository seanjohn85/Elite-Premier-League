//
//  TeamParent.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 18/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SwiftyJSON

class TeamParent: SCNNode {
    
    var colour = GlobalVar.green
    //creates empty json array for league table data
    var leagueTable = JSON("empty")
    private var arItem = 0
    private var team : Team?
    //this will be used to create an invisable parent node object, all elemts related to this team will
    init(geometry: SCNGeometry = SCNPlane(width: 3.5, height: 3.5)) {
        super.init()
        self.geometry = geometry
        //sets node to transparent
        self.geometry?.firstMaterial?.diffuse.contents  = GlobalVar.clear
        //sets the colour of this
        setColour()
    }
    
    //sets a random colour for child nodes
    private func setColour(){
        colour = GlobalVar.mainColours[Int(arc4random_uniform(UInt32(GlobalVar.mainColours.count)))]
    }
    
    
    //used to loop through the 3 different ar options on this screen and move to next option and remove the previous node
    func changeARPlane(){
        if arItem == 0{
            //
            self.childNode(withName: "fixtureNode", recursively: true)?.removeFromParentNode()
            //show the players plane
            self.addPlayersNode()
            //moves the menu to the next phase
            arItem = 1
        }else if arItem == 1{
            //remove the playerNode node
            self.childNode(withName: "playerNode", recursively: true)?.removeFromParentNode()
            //show the players plane
            self.addTabelNode()
            //moves the menu to the next phase
            
            arItem = 2
        }else if arItem == 2{
            //remove the playerNode node
            self.childNode(withName: "tabelNode", recursively: true)?.removeFromParentNode()
            
            //moves the menu to the next phase
            arItem = 3
        }else if arItem == 3{
            //show the players plane
            self.addFixture()
            //moves the menu to start
            arItem = 0
        }
    }
    
    //adds the fixtures node to the parent
    private func addFixture(){
        let fixtureNode = FixtureNode()
        if let nodeTeam = self.team {
            fixtureNode.setup(newColour : colour)
            fixtureNode.addContent(team: nodeTeam)
            self.addChildNode(fixtureNode)
        }
    }
    
    //adds the player node to the parent
    private func addPlayersNode(){
        let playerNode = PlayerNode()
        if let nodePlayers = self.team?.players {
            playerNode.setup(newColour : colour)
            playerNode.thisPlayers = nodePlayers
            self.addChildNode(playerNode)
        }
    }
    
    //adds the player node to the parent
    private func addTabelNode(){
        let tabelNode = TableNode()
        tabelNode.leagueTable = self.leagueTable
        tabelNode.setup(newColour : colour)
        tabelNode.populateTable()
        self.addChildNode(tabelNode)

    }
    
    
    //set or get team
    var thisTeam : Team{
        get
        {
            return self.team!
        }
        set
        {
            self.team = newValue
            self.addFixture()
        }
    }
    
    
    // SCNNode objects require this
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
