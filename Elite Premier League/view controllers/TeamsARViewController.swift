//
//  TeamsARViewController.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 18/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON

class TeamsARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var inforBar: UILabel!
    //used to check if a crest is been checked
    private var teamFound = false
    //connection to the ar scene module
    @IBOutlet weak var sceneView: ARSCNView!
    private var visionRequests = [VNRequest]()
    //used to hold the points in the world where the screen was pressed
    private var hitTestResult : ARHitTestResult!
    //sets the AR configuration
    private let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        //runs the preset configuration in the scene to track the real world
        sceneView.session.run(configuration)
        //adds tap gesture recongnizer to allow the user to interact with the screen
        loadTapGestureRecognizer()
    }

    //enable the tab gersueres on the screen
    private func loadTapGestureRecognizer(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //when the screen is tapped this is triggered
    @objc func tapped(recognizer : UIGestureRecognizer){
        //checks id a ar element is been touched by the user
        let sceneTappendOn = recognizer.view as! SCNView
        let touchCoord = recognizer.location(in: sceneTappendOn)
        let hitTest = sceneTappendOn.hitTest(touchCoord)
        //if no node is touched it should be an image
        if hitTest.isEmpty{
            print("not tocuhing a node")
            extractImage(recognizer : recognizer)
        }else{
            //doesnt need to be unwrapped as will not
            let res = hitTest.first!
            //when the menu nod eis pressed
            if res.node.name == "menu" {
                print("men")
                //change to the next plane
                let parent = res.node.parent as! TeamParent
                parent.changeARPlane()
                //if its the players plane and its touched change to next player
            }else if res.node.name == "playerNode"{
                
            }else if res.node.parent?.name == "playerNode"{
                print("change player")
                //gets the next players image from the server
                let parent = res.node.parent as! PlayerNode
                parent.nextPlayer()
            }
        }
    }
    
    //pass the image tho the model
    private func extractImage(recognizer : UIGestureRecognizer){
        
        let sceneRecognizer = recognizer.view as! ARSCNView
        //checks id a ar element is been touched by the user
        let touchLoaction = self.sceneView.center
        
        guard let currentframe = sceneRecognizer.session.currentFrame else {
            print ("nothing in frame")
            return
        }
        
        let hitTestResults = sceneRecognizer.hitTest(touchLoaction, types: .featurePoint)
        
        if hitTestResults.isEmpty{
            self.inforBar.text = "Issue with image. Please ensure camera is still and in focus and try again."
            print("nothing in hittest")
            return
        }
        
        guard let hitTestResult = hitTestResults.first else {
            print ("nothing in frame")
            return
        }
        
        self.hitTestResult = hitTestResult
        //image from current frame
        let pixelBufImage = currentframe.capturedImage
        //check the image with the vison model
        if !teamFound{
            analyiseImage(image: pixelBufImage)
        }
    }
    
    //creates a vision request to analiyze the image
    private func analyiseImage(image : CVPixelBuffer){
        //converts the model to a vuison model
        let visionModel =  try! VNCoreMLModel(for: GlobalVar.model.model)
        //creates a vision request with the model
        let request = VNCoreMLRequest(model: visionModel, completionHandler: results)
        request.imageCropAndScaleOption = .scaleFill
        let handler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .upMirrored, options: [:])
        //only one request
        try! handler.perform([request])
   
    }
    
    //a vision requestion event handler
    func results(request: VNRequest, error : Error?){
        //if cant get an output exit this fuction to avoid the app crashing
        guard let prediction = request.results as? [VNClassificationObservation] else{
            fatalError("could not get any output")
        }
        
        guard let observ = request.results else {
            return
        }
        teamFound = true
        //gets the first result from the cnn
        let ob = observ.first as! VNClassificationObservation
        print("\(ob.identifier) - Confidence: \(ob.confidence)")
        //only get the team data if the convidence is high
        if ob.confidence > 0.60{
            print("match ")
            //gets the teams dat from the server
            requestTeamData(teamName: ob.identifier)
        }
        else{
            self.inforBar.text = "I'm not sure of this team. Please check the camera focus and ensure the crest is fully on screen."
            teamFound = false
        }
    }
    
    
    
    //fucntion to request the data of the found team from the server
    func requestTeamData(teamName: String){
        let parameters: Parameters = ["name": teamName]
        print("get server request")
        let url = GlobalVar.teamData
        var currentTeam : Team?
        //request to Django server ---  NB *******Django server Must Be started***********
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
                print("sent")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                //if there was a response
                if ((response.result.value) != nil) {
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    //debugPrint(response)
                    print(swiftyJsonVar["team"])
                    //update the team using the current teams details
                    currentTeam  = Team(name : swiftyJsonVar["team"]["name"].rawString()!,code : Int(swiftyJsonVar["team"]["code" ].rawString()!)!,
                                                  defHome   : Int(swiftyJsonVar["team"]["strength_defence_home" ].rawString()!)!,
                                                  attHome   : Int(swiftyJsonVar["team"]["strength_attack_home"].rawString()!)!,
                                                  home      : Int(swiftyJsonVar["team"]["strength_overall_home" ].rawString()!)!,
                                                  defAway   : Int(swiftyJsonVar["team"]["strength_defence_away"].rawString()!)!,
                                                  attAway   : Int(swiftyJsonVar["team"]["strength_attack_away" ].rawString()!)!,
                                                  away      : Int(swiftyJsonVar["team"]["strength_overall_away" ].rawString()!)!)
                    
                    
                    print(swiftyJsonVar)
                    //creates a fiture object
                    let fixture = Fixture(
                        homeTeam    : swiftyJsonVar["fixture"]["homeTeam"].rawString()!,
                        awayTeam    : swiftyJsonVar["fixture"]["awayTeam"].rawString()!,
                        date        : swiftyJsonVar["fixture"]["date"].rawString()!,
                        homeGoals   : Int(swiftyJsonVar["fixture"]["homeGoals"].rawString()!)!,
                        awayGoals   : Int(swiftyJsonVar["fixture"]["awayGoals"].rawString()!)!)
                    print(swiftyJsonVar["table"])
                    currentTeam?.thisFixture = fixture
                    print("players")
                    //creates a list of players from the json
                    let list: Array<JSON> = swiftyJsonVar["players"].arrayValue
                    //loops through the list of players
                    var players = [Player] ()
                    for p in list{
                        //creates a player object
                        let named = Player(playerId      : Int(p["playerId"].rawString()!)!,
                                           team          : currentTeam!,
                                           fName         : p["f_name"].rawString()!,
                                           lName         : p["l_name"].rawString()!,
                                           pos           : Int(p["pos"].rawString()!)!,
                                           goals         : Int(p["goals"].rawString()!)!,
                                           assits        : Int(p["assits"].rawString()!)!,
                                           saves         : Int(p["saves"].rawString()!)!,
                                           number        : Int(p["number"].rawString()!)!,
                                           cleanSheets   : Int(p["clean_sheets"].rawString()!)!,
                                           ownGoals      : Int(p["own_goals"].rawString()!)!,
                                           penoSaved     : Int(p["penalties_saved"].rawString()!)!,
                                           penoMissed    : Int(p["penalties_missed"].rawString()!)!,
                                           photoURL      : p["photo"].rawString()!,
                                           yellowCards   : Int(p["yellow_cards"].rawString()!)!,
                                           redCards      : Int(p["red_cards"].rawString()!)!)
                        print(named.returnDetails())
                        //checks if the player has any news
                        if !p["news"].rawString()!.isEmpty{
                            named.thisNews = p["news"].rawString()!
                        }
                        //adds each player to the teams list of players
                        players.append(named)
                        
                        //GlobalVar.currentTeam?.addPlayer(player: named)
                        print("\(currentTeam?.players?.count)")
                        
                    }
                    //sets the teams players
                    currentTeam?.thisPlayers = players
                    
                    //create a parent node and add its child nodes
                    let parentNode = TeamParent()
                    parentNode.thisTeam = currentTeam!
                    parentNode.leagueTable = swiftyJsonVar["table"]
                    
                    //postions relative to the scanned crest
                    //let z = self.hitTestResult.worldTransform.columns.3.z - Float(GlobalVar.randomNumbers(firstNum: -6, secondNum: -4))
                    parentNode.position = SCNVector3(self.hitTestResult.worldTransform.columns.3.x,self.hitTestResult.worldTransform.columns.3.y, Float(GlobalVar.randomNumbers(firstNum: -6, secondNum: -4)))
                    //adds the menu top the parent
                    parentNode.addChildNode(self.addMenu(team : parentNode.thisTeam.thisName))
                    //parentNode.addChildNode(self.addFixture(team: parentNode.team!))
                    //adds the node to the scene
                    self.sceneView.scene.rootNode.addChildNode(parentNode)
                    self.teamFound = false
                }else{
                    //issue connecting to server
                    self.inforBar.text = "Could not connect to the server please check your internet connection"
                    self.teamFound = false
                }
            }
    }
    //this fuction is used to add the sphere menu node
    func addMenu(team : String) -> SCNNode{
        //sets the radius of the menu node
        let menuNode = MenuNode(geometry : SCNSphere(radius: 0.4))
        //sets the texture on the node
        menuNode.setUp(imageName: team)
        //returns the menu
        return menuNode
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
