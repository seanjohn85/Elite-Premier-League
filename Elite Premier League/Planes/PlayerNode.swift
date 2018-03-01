//
//  PlayerNode.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 21/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class PlayerNode: SCNNode {
    
    private var players : [Player]?

    //used to track current player object in the players array
    private var currentPlayer = 0
    //this will be used to create an invisable parent node object, all elemts related to this team will
    init(geometry: SCNGeometry = SCNPlane(width: 3.5, height: 2.2)) {
        super.init()
        self.geometry = geometry
        //set up fixture node
        setup()
    }
    
    private func setup(){
        //sets it to green
        self.geometry?.firstMaterial?.diffuse.contents  = UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 0.8)
        //positions it in the center of the x and y of the parent Node with 0.1 meeters away from the user in the z axsis
        self.position = SCNVector3(0, 0, 0.1)
        //named node to be identifed for removal
        self.name = "playerNode"
        
    }
    
    //function to get a players image from the server
    func getPlayerImageFromServer(player : Player){
        //the url of the image
        let url = "\(GlobalVar.imagesUrl)/\(player.imageLocation())"
        //let url = "http://192.168.0.157:8080/static/images/1/9808.png"
        ///server request to download the image
        
        Alamofire.request(url).responseImage { response in
            debugPrint(response)
            
            print(response.request ?? "none")
            print(response.response ?? "none")
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                //uses the image as a pram to create
                self.addPlayerToPlane(image : image, player : player)
            }
        }
    }
    
    
    //used to fill a plane with a new player
    func addPlayerToPlane(image : UIImage, player: Player){
        //removes previous players details from the player node
        self.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode() }
        //adds the crest to the node pram as a child
        
        self.addChildNode(GlobalVar.addImage(image : image, w : 1.3, h : 1.3, x : -0.85, y : 0.25))
        //results node
        let playerName = SCNNode(geometry : SCNPlane(width: 1.3, height: 0.50))
        //results label
        
        let name = NodeLabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(800), height: CGFloat(100)))
        name.labelGenerator(width: 800, height : 100, textColour :  UIColor(red: 56.0 / 255.0, green: 0 / 255.0, blue: 60.0 / 255.0, alpha: 1), bgColour : UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 0), size : 70, text : player.returnDetails())
        //adds the results label to the node
        playerName.geometry?.firstMaterial?.diffuse.contents = name.convertLabelToImage()
        //postions the node
        playerName.position = SCNVector3(-0.85, -0.70, 0.1)
        //adds the node as a child node
        self.addChildNode(playerName)
        //lets the saves and clean shest label
        if player.thisPos == 1{
            print("goalkeeper")
            self.addChildNode(statNodeGen(name : "Saves", stat : String(player.thisSaves), x : 0.80, y  : 0.75))
            self.addChildNode(statNodeGen(name : "Clean Sheets", stat : String(player.thisCleanSheets), x : 0.80, y  : 0.40))
            //for outfield players sets the goals and assits labels
        }else{
            self.addChildNode(statNodeGen(name : "Goals", stat : String(player.thisGoals), x : 0.80, y  : 0.75))
            self.addChildNode(statNodeGen(name : "Assits", stat : String(player.thisAssists), x : 0.80, y  : 0.40))
        }
        //adds the node as a child node for red and yellow cards
        self.addChildNode(statNodeGen(name : "Yellow Cards", stat : String(player.thisYellow), x : 0.80, y  : 0.05))
        self.addChildNode(statNodeGen(name : "Red Cards", stat : String(player.thisRed), x : 0.80, y  : -0.30))
        //self.sceneKit.scene.rootNode.childNode(withName: "playerNode", recursively: true)?.addChildNode(statNodeGen(name : "", stat : "", x : 0.80, y  : -0.70))
    }
    
    
    //function to get the next player
    private func getNextPlayer() -> Player{
        //when the curent palyer is the last player reset to thecounter to 0
        if self.currentPlayer == (self.players?.count)! - 1{
            self.currentPlayer = 0
        }
        //gets the next player
        let player = (self.players?[currentPlayer])!
        //increment player counter
        self.currentPlayer += 1
        //returns the player
        return player
    }
    
    
    //creates nodes using the stats custom view for player stats
    private func statNodeGen(name : String, stat : String, x : Double, y  : Double) -> SCNNode{
        //creats a stats view object
        let view = StatsView(frame: CGRect(x: CGFloat(0), y: CGFloat(0),
                                           width: 550, height: 100))
        //sets the text lables on the view
        view.nameLabel.text = name
        view.nameLabel.adjustsFontSizeToFitWidth = true
        view.statLabel.text = stat
        view.nameLabel.adjustsFontSizeToFitWidth = true
        //creates a custom node
        let stat = SCNNode(geometry : SCNPlane(width: 1.5, height: 0.25))
        //adds the cucsom views image as material to the node
        
        stat.geometry?.firstMaterial?.diffuse.contents = GlobalVar.convertViewToImage(view : view)
        //postions the node
        stat.position = SCNVector3(x, y, 0.1)
        //returns the node
        return stat
    }
    
    
    func nextPlayer(){
        
        getPlayerImageFromServer(player : getNextPlayer())
        animate()
    }
    
    
    
    //animate model
    func animate(){
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = self.presentation.position
        spin.toValue = SCNVector3(self.presentation.position.x - 0.2 ,self.presentation.position.y - 0.2,self.presentation.position.z - 15)
        spin.duration = 0.5
        spin.repeatCount = 1
        //smooth animate back to current pos
        spin.autoreverses = true
        self.addAnimation(spin, forKey: "position")
    }

    var thisPlayers : [Player]{
        get
        {
            return players!
        }
        set
        {
            self.players = newValue
            //self.addFixture()
            getPlayerImageFromServer(player : getNextPlayer())
        }
    }
    
    // SCNNode objects require this 
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
