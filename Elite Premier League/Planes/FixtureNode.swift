//
//  Fixture.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 21/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class FixtureNode: SCNNode {
    
    private var colour = GlobalVar.green
    
    //this will be used to create an invisable parent node object, all elemts related to this team will
    init(geometry: SCNGeometry = SCNPlane(width: 3, height: 2.5)) {
        super.init()
        self.geometry = geometry
        
    }

    //used to set up a fixture node
    func setup(newColour : UIColor){
        self.colour = newColour
        //sets it to green
        self.geometry?.firstMaterial?.diffuse.contents  = colour.withAlphaComponent(0.8)
        //positions it in the center of the x and y of the parent Node with 0.1 meeters away from the user in the z axsis
        self.position = SCNVector3(0, 0, 0.1)
        //named node to be identifed for removal
        self.name = "fixtureNode"
    }
    //adds the content to the fixture node
    func addContent(team : Team){
        //add the date to the fixture node
        addDateNode(date: team.thisFixture.thisDate)
        //add the crest images
        addCrests(team : team)
        //addd the team names node
        addTeamNames(team : team)
        
        prediction(team : team)
    }
    
    //function to add a lable node with the date
    private func addDateNode(date : String){
        //create a plane to house the date
        let dateNode = SCNNode(geometry : SCNPlane(width: 2, height: 0.2))
        dateNode.position = SCNVector3(0, 1, 0.1)
        //creates the datelabel
        let dateLabel = NodeLabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(300), height: CGFloat(100)))
        //uses the custom lales function to colour the label and text
        dateLabel.labelGenerator(width: 300, height : 100, textColour : GlobalVar.navy, bgColour : GlobalVar.clear, size : 40, text : date)
        //converts the lable to an image and uses the image as the nodes texture
        dateNode.geometry?.firstMaterial?.diffuse.contents = dateLabel.convertLabelToImage()
        //adds the date node as a child of the
        self.addChildNode(dateNode)
    }
    
    //adds the crest of both teams aon the selected teams next game
    private func addCrests(team : Team){
        //add a node with the home teams crest
        self.addChildNode(GlobalVar.addImage(imageName: team.thisFixture.thisHomeTeam, x: -0.68, y: 0.45))
        //add a node with the away teams crest
        self.addChildNode(GlobalVar.addImage(imageName: team.thisFixture.thisAwayTeam, x: 0.68, y: 0.45))
    }
    
    private func addTeamNames(team : Team){
        //cretes a node to hold the team names
        let teamNames = SCNNode(geometry : SCNPlane(width: 2.98, height: 0.4))
        let teamsLabel = NodeLabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(800), height: CGFloat(100)))
        //creats a label with the team names
        teamsLabel.labelGenerator(width: 800, height : 100, textColour : .white, bgColour : GlobalVar.navy, size : 60, text : "\(team.thisFixture.thisHomeTeam)    V   \(team.thisFixture.thisAwayTeam) ")
        //adds the lable to the ndoe
    teamNames.geometry?.firstMaterial?.diffuse.contents = teamsLabel.convertLabelToImage()
        //postions the node
        teamNames.position = SCNVector3(0, -0.35, 0.04)
        //adds the node as a child to the main fixtures plane
        self.addChildNode(teamNames)
    }
    
    
    private func prediction(team : Team){
        //prediction node
        let prediction = SCNNode(geometry : SCNPlane(width: 1.5, height: 0.4))
        //prediction label
        let predictionLabel = NodeLabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(800), height: CGFloat(100)))
        predictionLabel.labelGenerator(width: 800, height : 100, textColour : .white, bgColour : GlobalVar.clear, size : 60, text : "Prediction:")
        //adds the label to the node
        prediction.geometry?.firstMaterial?.diffuse.contents = predictionLabel.convertLabelToImage()
        //postions the node
        prediction.position = SCNVector3(-1.0, -0.85, 0.1)
        //adds the new node as a child to the main plane
        self.addChildNode(prediction)
        //results node
        let predictionRes = SCNNode(geometry : SCNPlane(width: 1.5, height: 0.4))
        //results label
        let predictionResLabel = NodeLabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(800), height: CGFloat(100)))
        predictionResLabel.labelGenerator(width: 800, height : 100, textColour :  GlobalVar.navy, bgColour : GlobalVar.clear, size : 60, text : "\(team.thisFixture.thisHomeGoals) - \(team.thisFixture.thisAwayGoals)")
        //adds the results label to the node
        predictionRes.geometry?.firstMaterial?.diffuse.contents = predictionResLabel.convertLabelToImage()
        //postions the node
        predictionRes.position = SCNVector3(0.20, -0.85, 0.1)
        //adds the node as a child node
        self.addChildNode(predictionRes)
    }
    
    // SCNNode objects require this 
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
