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
    

    @IBOutlet weak var sceneKit: ARSCNView!
     let configuration = ARWorldTrackingConfiguration()
    
    let node = SCNNode(geometry : SCNPlane(width: 3, height: 2.5))
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        sceneKit.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sceneKit.session.run(configuration)
        

        
        node.geometry?.firstMaterial?.diffuse.contents  = UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 0.8)
        node.position = SCNVector3(0, 0, -5)
        self.sceneKit.scene.rootNode.addChildNode(node)
        
        
        //create a plane to house the date
        let dateNode = SCNNode(geometry : SCNPlane(width: 2, height: 0.2))
        dateNode.position = SCNVector3(0, 1, 0.1)
        let dateLabel = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0),
                                          width: CGFloat(300), height: CGFloat(100)))
        dateLabel.textColor = UIColor(red: 56.0 / 255.0, green: 0.0 / 255.0, blue: 60 / 255.0, alpha: 1)
        dateLabel.layer.backgroundColor = UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 0.1).cgColor
        dateLabel.textAlignment = NSTextAlignment.center
        //sets the text on the label
        dateLabel.text = GlobalVar.currentTeam?.thisFixture.thisDate
        //sets the font to the app font
        dateLabel.font = UIFont (name: "Premier League", size: 40)
        //adjusts text to fit
        dateLabel.adjustsFontSizeToFitWidth = true
        //test need to be converted to an image to remove background
        dateNode.geometry?.firstMaterial?.diffuse.contents = convertLabelToImage(label : dateLabel)
        node.addChildNode(dateNode)
        //ensures the fixtures contains a home team
        if let crest = GlobalVar.currentTeam?.thisFixture.thisHomeTeam{
            print("Home team \(crest)")
            //adds the crest to the fixtures plane
            addCrest(crestName : crest, x : -0.68, y : 0.45, node: node)
        }
        //ensures the fixtures contains an away team
        if let crest = GlobalVar.currentTeam?.thisFixture.thisAwayTeam{
            print("away team \(crest)")
            //adds the crest to the fixtures plane
            addCrest(crestName : crest, x :0.68, y : 0.45, node: node)
           // getPlayerImageFromServer(/*player : Player*/)
        }
        
        
    
       
        
        let teamNames = SCNNode(geometry : SCNPlane(width: 2.98, height: 0.4))
        let label = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0),
                                          width: CGFloat(800), height: CGFloat(100)))
        
        label.textColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        label.layer.backgroundColor = UIColor(red: 56.0 / 255.0, green: 0 / 255.0, blue: 60.0 / 255.0, alpha: 1).cgColor
        label.text = "\(GlobalVar.currentTeam!.thisFixture.thisHomeTeam)    V   \(GlobalVar.currentTeam!.thisFixture.thisAwayTeam) "
        label.font = UIFont (name: "Premier League", size: 60)
        label.adjustsFontSizeToFitWidth = true
        teamNames.geometry?.firstMaterial?.diffuse.contents = label
        
        teamNames.position = SCNVector3(0, -0.35, 0.04)
        node.addChildNode(teamNames)
        
        //prediction label
        
        let prediction = SCNNode(geometry : SCNPlane(width: 1.5, height: 0.4))
        let predictionLabel = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0),
                                          width: CGFloat(800), height: CGFloat(100)))
        
        
        
        predictionLabel.textColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        predictionLabel.textAlignment = NSTextAlignment.center
        predictionLabel.layer.backgroundColor = UIColor(red: 56.0 / 255.0, green: 0 / 255.0, blue: 60.0 / 255.0, alpha: 0).cgColor
        predictionLabel.text = "Prediction:"
        predictionLabel.font = UIFont (name: "Premier League", size: 60)
        predictionLabel.adjustsFontSizeToFitWidth = true
        
    
        prediction.geometry?.firstMaterial?.diffuse.contents = convertLabelToImage(label : predictionLabel)
        
        prediction.position = SCNVector3(-1.0, -0.85, 0.1)
        node.addChildNode(prediction)
        
        let predictionRes = SCNNode(geometry : SCNPlane(width: 1.5, height: 0.4))
        let predictionResLabel = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0),
                                                    width: CGFloat(800), height: CGFloat(100)))
        
        
        
        predictionResLabel.textColor = UIColor(red: 56.0 / 255.0, green: 0 / 255.0, blue: 60.0 / 255.0, alpha: 1)
        predictionResLabel.textAlignment = NSTextAlignment.center
        predictionResLabel.layer.backgroundColor = UIColor(red: 56.0 / 255.0, green: 0 / 255.0, blue: 60.0 / 255.0, alpha: 0).cgColor
        predictionResLabel.text = "\(GlobalVar.currentTeam!.thisFixture.thisHomeGoals) - \(GlobalVar.currentTeam!.thisFixture.thisAwayGoals)"
        predictionResLabel.font = UIFont (name: "Premier League", size: 60)
        predictionResLabel.adjustsFontSizeToFitWidth = true
        
        
        predictionRes.geometry?.firstMaterial?.diffuse.contents = convertLabelToImage(label : predictionResLabel)
        
        predictionRes.position = SCNVector3(0.65, -0.85, 0.1)
        node.addChildNode(predictionRes)
        
        
        
        
        
        addMenu()
        
        
        print("fixture details \(String(describing: GlobalVar.currentTeam?.thisFixture.thisHomeTeam)) \(GlobalVar.currentTeam?.thisFixture.thisAwayTeam ?? "no away team") \(String(describing: GlobalVar.currentTeam?.thisFixture.thisDate)) \(GlobalVar.currentTeam?.thisFixture.thisAwayGoals ?? 0) \(String(describing: GlobalVar.currentTeam?.thisFixture.thisHomeGoals))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addMenu(){
        let menuNode = SCNNode()
        menuNode.geometry = SCNSphere(radius: 0.1)
        menuNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "\(GlobalVar.currentTeam!.thisName)Texture")
        menuNode.position = SCNVector3(-0.35, 0.4, -1)
        self.sceneKit.scene.rootNode.addChildNode(menuNode)
        
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degree2Rad), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        menuNode.runAction(forever)
    }
    
    func addFixture(){
        
    }
    
    //function to add a crest to the fixtures plane
    func addCrest(crestName : String, x : Double, y : Double, node: SCNNode){
        //crests a new node
        let crestNode = SCNNode(geometry : SCNPlane(width: 0.7, height: 0.7))
        //appends the crest image to the node palne
        crestNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "\(crestName)Crest")
        //positions the crest using the given the x and y pos prams
        crestNode.position = SCNVector3(x, y, 0.1)
        //adds the crest to the node pram as a child
        node.addChildNode(crestNode)
    }
    
    
    func addImagePlane(){
        
    }
    
    func addTextToNode(){
        
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
        //the url of the image
        //let url = "\(GlobalVar.imagesUrl)\(player.imageLocation())"
        let url = "http://192.168.0.157:8080/static/images/1/9808.png"
        ///server request to download the image
        
        Alamofire.request(url).responseImage { response in
            debugPrint(response)
            
            print(response.request ?? "none")
            print(response.response ?? "none")
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                /*let crestNode = SCNNode(geometry : SCNPlane(width: 0.7, height: 0.7))
                //appends the crest image to the node palne
                crestNode.geometry?.firstMaterial?.diffuse.contents = image
                    //positions the crest using the given the x and y pos prams
                crestNode.position = SCNVector3(0.68, 0.45, 0.1)
                //adds the crest to the node pram as a child
                self.node.addChildNode(crestNode)*/
            }
        
       
        }
        
    }

}

extension Int {
    var degree2Rad: Double { return Double(self) * .pi/180}
}
