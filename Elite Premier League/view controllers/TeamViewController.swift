//
//  TeamViewController.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 31/01/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import Alamofire
import AlamofireImage


class TeamViewController: UIViewController, ARSCNViewDelegate{
    
    //link to the ar sceen to add elements
    @IBOutlet weak var sceneKit: ARSCNView!
    //sets the AR configuration
    let configuration = ARWorldTrackingConfiguration()
    //used to track current player object in the players array
    var currentPlayer = 0
    // this is used to detect what ar plane is currently shown.... 0 is the fixtures plane
    var arItem = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneKit.delegate = self
        //runs the preset configuration in the scene to track the real world
        sceneKit.session.run(configuration)
        
        //loads the fixture plane
        fixture()
        //loades the menu node
        addMenu()
        
        //when box is tapped
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        
        self.sceneKit.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //when the view appears
    override func viewDidAppear(_ animated: Bool) {
        //test print
        print("fixture details \(String(describing: GlobalVar.currentTeam?.thisFixture.thisHomeTeam)) \(GlobalVar.currentTeam?.thisFixture.thisAwayTeam ?? "no away team") \(String(describing: GlobalVar.currentTeam?.thisFixture.thisDate)) \(GlobalVar.currentTeam?.thisFixture.thisAwayGoals ?? 0) \(String(describing: GlobalVar.currentTeam?.thisFixture.thisHomeGoals))")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //this fuction is used to add the sphere menu node
    func addMenu(){
        let menuNode = SCNNode(geometry : SCNSphere(radius: 0.1))
        //menuNode.geometry = SCNSphere(radius: 0.1)
        menuNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "\(GlobalVar.currentTeam!.thisName)Texture")
        //positions the node in real world using x y z axis in meters
        menuNode.position = SCNVector3(-0.35, 0.4, -1)
        //used to detect id touched
        menuNode.name = "menu"
        //adds the node to the ar scene
        self.sceneKit.scene.rootNode.addChildNode(menuNode)
        //creates a 360 degree roatation that lasts for 8 seconds
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degree2Rad), z: 0, duration: 8)
        //loops the rotation to repeat
        let forever = SCNAction.repeatForever(action)
        //adds the roatation animation to the menu node
        menuNode.runAction(forever)
        
    }
    
    //the fixture plane will be created and added here
    func fixture(){
        //the plane to show the fixures
        let fixtureNode = SCNNode(geometry : SCNPlane(width: 3, height: 2.5))
        //sets it to green
        fixtureNode.geometry?.firstMaterial?.diffuse.contents  = UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 0.8)
        //positions it in the center of the x and y of the world with -5 meeters away from the user in the z axsis
        fixtureNode.position = SCNVector3(0, 0, -5)
        //named node to be identifed for removal
        fixtureNode.name = "fixtureNode"
        self.sceneKit.scene.rootNode.addChildNode(fixtureNode)
        
        //create a plane to house the date
        let dateNode = SCNNode(geometry : SCNPlane(width: 2, height: 0.2))
        dateNode.position = SCNVector3(0, 1, 0.1)
        //creates the datelabel
        let dateLabel = labelGenerator(width: 300, height : 100, textColour : UIColor(red: 56.0 / 255.0, green: 0.0 / 255.0, blue: 60 / 255.0, alpha: 1), bgColour : UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 0), size : 40, text : (GlobalVar.currentTeam?.thisFixture.thisDate)!)
        
        //test need to be converted to an image to remove background
        dateNode.geometry?.firstMaterial?.diffuse.contents = convertLabelToImage(label : dateLabel)
        fixtureNode.addChildNode(dateNode)
        //ensures the fixtures contains a home team
        if let crest = GlobalVar.currentTeam?.thisFixture.thisHomeTeam{
            print("Home team \(crest)")
            //adds the crest to the fixtures plane
            fixtureNode.addChildNode(addCrest(crestName : crest, x : -0.68, y : 0.45))
        }
        //ensures the fixtures contains an away team
        if let crest = GlobalVar.currentTeam?.thisFixture.thisAwayTeam{
            print("away team \(crest)")
            //adds the crest to the fixtures plane
            //adds the crest to the node pram as a child
            fixtureNode.addChildNode(addCrest(crestName : crest, x :0.68, y : 0.45))
            // getPlayerImageFromServer(/*player : Player*/)
        }
        //cretes a node to hold the team names
        let teamNames = SCNNode(geometry : SCNPlane(width: 2.98, height: 0.4))
        //creats a label with the team names
        let teamsLabel = labelGenerator(width: 800, height : 100, textColour : UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1), bgColour : UIColor(red: 56.0 / 255.0, green: 0 / 255.0, blue: 60.0 / 255.0, alpha: 1), size : 60, text : "\(GlobalVar.currentTeam!.thisFixture.thisHomeTeam)    V   \(GlobalVar.currentTeam!.thisFixture.thisAwayTeam) ")
        //adds the lable to the ndoe
        teamNames.geometry?.firstMaterial?.diffuse.contents = teamsLabel
        //postions the node
        teamNames.position = SCNVector3(0, -0.35, 0.04)
        //adds the node as a child to the main fixtures plane
        fixtureNode.addChildNode(teamNames)
        
        //prediction node
        let prediction = SCNNode(geometry : SCNPlane(width: 1.5, height: 0.4))
        //prediction label
        let predictionLabel = labelGenerator(width: 800, height : 100, textColour : UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1), bgColour : UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 0), size : 60, text : "Prediction:")
        //adds the label to the node
        prediction.geometry?.firstMaterial?.diffuse.contents = convertLabelToImage(label : predictionLabel)
        //postions the node
        prediction.position = SCNVector3(-1.0, -0.85, 0.1)
        //adds the new node as a child to the main plane
        fixtureNode.addChildNode(prediction)
        //results node
        let predictionRes = SCNNode(geometry : SCNPlane(width: 1.5, height: 0.4))
        //results label
        let predictionResLabel = labelGenerator(width: 800, height : 100, textColour :  UIColor(red: 56.0 / 255.0, green: 0 / 255.0, blue: 60.0 / 255.0, alpha: 1), bgColour : UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 0), size : 60, text : "\(GlobalVar.currentTeam!.thisFixture.thisHomeGoals) - \(GlobalVar.currentTeam!.thisFixture.thisAwayGoals)")
        //adds the results label to the node
        predictionRes.geometry?.firstMaterial?.diffuse.contents = convertLabelToImage(label : predictionResLabel)
        //postions the node
        predictionRes.position = SCNVector3(0.65, -0.85, 0.1)
        //adds the node as a child node
        fixtureNode.addChildNode(predictionRes)
    }
    
    //the players planes will be created and added here
    func players(){
        //the plane to show the fixures
        let playerNode = SCNNode(geometry : SCNPlane(width: 3, height: 2.5))
        //sets it to green
        playerNode.geometry?.firstMaterial?.diffuse.contents  = UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 0.8)
        //positions it in the center of the x and y of the world with -5 meeters away from the user in the z axsis
        playerNode.position = SCNVector3(0, 0, -5)
        //named node to be identifed for removal
        playerNode.name = "playerNode"
        self.sceneKit.scene.rootNode.addChildNode(playerNode)
    }
    
    //the players planes will be created and added here
    func table(){
        
    }
    
    //function to add a crest to the fixtures plane
    func addCrest(crestName : String, x : Double, y : Double) -> SCNNode{
        //crests a new node
        let crestNode = SCNNode(geometry : SCNPlane(width: 0.7, height: 0.7))
        //appends the crest image to the node palne
        crestNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "\(crestName)Crest")
        //positions the crest using the given the x and y pos prams
        crestNode.position = SCNVector3(x, y, 0.1)
        return crestNode
        
    }
    
    
    func addImagePlane(){
        
    }
    
    func addTextToNode(){
        
    }
    

    //used to create text labels for the
    func labelGenerator(width: Double, height : Double, textColour : UIColor, bgColour : UIColor, size : Double, text : String) -> UILabel{
        //creates a UI Label
        let label = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0),
                                          width: CGFloat(width), height: CGFloat(height)))
        //sets the colour of the labels text
        label.textColor = textColour
        //alligns text to center of the label
        label.textAlignment = NSTextAlignment.center
        label.layer.backgroundColor = bgColour.cgColor
        //adds the text to the label
        label.text = text
        //sets the font and text size
        label.font = UIFont (name: "Premier League", size: CGFloat(size))
        //ensures text is adjusted
        label.adjustsFontSizeToFitWidth = true
        //returns the label
        return label
    }
    
    //used to convert a uilable to a uiimage as its required to have no background on a plane node
    func convertLabelToImage(label : UILabel) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        label.drawHierarchy(in: label.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!;
    }
    
    
    func getPlayerImageFromServer(/*player : Player*/){
        
        if self.currentPlayer == GlobalVar.currentTeam?.players!.count{
            self.currentPlayer == 0
        }
        print(GlobalVar.currentTeam?.players?[currentPlayer].returnDetails())
        
        //checks if there is a player
        guard let named = GlobalVar.currentTeam?.players?[self.currentPlayer].imageLocation() else {
            //exits fuction as the pleyer doesnt exist
            return
        }
        
        //the url of the image
        let url = "\(GlobalVar.imagesUrl)/\(named)"
        //let url = "http://192.168.0.157:8080/static/images/1/9808.png"
        ///server request to download the image
        
        Alamofire.request(url).responseImage { response in
            debugPrint(response)
            
            print(response.request ?? "none")
            print(response.response ?? "none")
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                let crestNode = SCNNode(geometry : SCNPlane(width: 0.7, height: 0.7))
                //appends the crest image to the node palne
                crestNode.geometry?.firstMaterial?.diffuse.contents = image
                    //positions the crest using the given the x and y pos prams
                crestNode.position = SCNVector3(0.68, 0.45, 0.1)
                //adds the crest to the node pram as a child
                self.sceneKit.scene.rootNode.childNode(withName: "playerNode", recursively: true)?.addChildNode(crestNode)
            }
        }
    }
    
    @objc func tapped(sender: UIGestureRecognizer){
        print("tapped")
        let sceneTappendOn = sender.view as! SCNView
        let touchCoord = sender.location(in: sceneTappendOn)
        
        let hitTest = sceneTappendOn.hitTest(touchCoord)
        if hitTest.isEmpty{
            print("not tocuhing a node")
        }else{
            //doesnt need to be unwrapped as will not
            let res = hitTest.first!
            if res.node.name == "menu" {
                print("men")
                changeARPlane()
            }else if res.node.name == "playerNode" {
                print("change player")
                getPlayerImageFromServer()
            }
            print(res.node.name ?? "no name")

        }
    }
    

    func changeARPlane(){
        if arItem == 0{
            //remove the fixture node
            self.sceneKit.scene.rootNode.childNode(withName: "fixtureNode", recursively: true)?.removeFromParentNode()
            //show the players plane
            self.players()
            //moves the menu to the next phase
            arItem = 1
        }else if arItem == 1{
            //remove the playerNode node
            self.sceneKit.scene.rootNode.childNode(withName: "playerNode", recursively: true)?.removeFromParentNode()
            //show the players plane
            self.table()
            //moves the menu to the next phase
            arItem = 2
        }else if arItem == 2{
            //remove the fixture node
            //self.sceneKit.scene.rootNode.childNode(withName: "fixtureNode", recursively: true)?.removeFromParentNode()
            //show the players plane
            self.fixture()
            //moves the menu to the next phase
            arItem = 0
        }
        
    }

    
    
}

//function to convert deg
extension Int {
    var degree2Rad: Double { return Double(self) * .pi/180}
}
