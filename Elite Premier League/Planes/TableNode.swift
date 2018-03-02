//
//  TableNode.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 21/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SwiftyJSON

class TableNode: SCNNode {
    
    private var colour = GlobalVar.green
    //view table top of bottom
    private var tableTop = true

    //creates empty json array for league table data
    var leagueTable = JSON("empty")
    
    //this will be used to create an invisable parent node object, all elemts related to this team will
    init(geometry: SCNGeometry = SCNPlane(width: 3.5, height: 2.8)) {
        super.init()
        self.geometry = geometry
        //set up fixture node
    }
    
    func setup(newColour : UIColor){
        self.colour = newColour
        //sets it to colour
        self.geometry?.firstMaterial?.diffuse.contents  = colour.withAlphaComponent(0.8)
        //positions it in the center of the x and y of the parent Node with 0.1 meeters away from the user in the z axsis
        self.position = SCNVector3(0, 0, 0.1)
        //named node to be identifed for removal
        self.name = "tabelNode"
        
    }
    
    
    //populates the table with the teams
    func populateTable(){
        var yPos = 0.80
        if tableTop == true {
            
            //genertates the top of the table
            for i in 1...10 {
                createTableRow(yPos : yPos, tablePos : i)
                yPos = yPos - 0.20
            }
            tableTop = false
        }else{
            //genertates the bottom of the table
            for i in 11...20 {
                createTableRow(yPos : yPos, tablePos : i)
                yPos = yPos - 0.20
            }
            tableTop = true
        }
    }
    
    
    private func createTableRow(yPos : Double, tablePos : Int){
        //creats a stats view object
        let view = LeagueTableRow(frame: CGRect(x: CGFloat(0), y: CGFloat(0),
                                                width: 1175, height: 54))
        //set the labels of the  row from the json recieved from the server
        //let gd = Int(leagueTable[tablePos-1]["goalsFor"].rawString()!)! - Int(leagueTable[tablePos-1]["goalsAgainst"].rawString()!)!
        view.positionLabel.text     = "\(tablePos)"
        view.teamNameLabel.text     = "\(leagueTable[tablePos-1]["team"])"
        view.playedLabel.text       = "\(leagueTable[tablePos-1]["played"])"
        view.wonLabel.text          = "\(leagueTable[tablePos-1]["win"])"
        view.drawnLabel.text        = "\(leagueTable[tablePos-1]["draw"])"
        view.lossLabel.text         = "\(leagueTable[tablePos-1]["loss"])"
        // view.gdLabel.text           = "\(gd)"
        view.ptsLabel.text          =  "\(leagueTable[tablePos-1]["points"])"
        //creates a custom node
        let row = SCNNode(geometry : SCNPlane(width: 3, height: 0.20))
        
        //adds the custom views image as material to the node
        row.geometry?.firstMaterial?.diffuse.contents = GlobalVar.convertViewToImage(view : view)
        //postions the node
        row.position = SCNVector3(0, yPos, 0.1)
        self.addChildNode(row)
        
    }
    
    // SCNNode objects require this 
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
