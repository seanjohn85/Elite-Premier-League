//
//  PogbaMiniGameViewController.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 06/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Each
import AVFoundation
import SCLAlertView
import BWWalkthrough


class PogbaMiniGameViewController: UIViewController, ARSCNViewDelegate, BWWalkthroughViewControllerDelegate {
    //audio player
    private var player: AVAudioPlayer?
    //ar scence link
    @IBOutlet var sceneView: ARSCNView!
    //text tables
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var timer: UILabel!
    //to keep the score and count
    var countdown = 10
    var scoreCount = 0
    //timer every second
    private var time = Each(1).seconds
    //links to the play button
    @IBOutlet weak var playBtn: UIButton!
    
    //sets the AR configuration
    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        //sets lighing
        self.sceneView.autoenablesDefaultLighting =  true
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        //when the screen is tapped
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //this objective c fuction is triggered by the selector when the screen is tapped
    @objc func tapped(sender: UIGestureRecognizer){
        //print("tapped")
        let sceneTappendOn = sender.view as! SCNView
        
        let touchCoord = sender.location(in: sceneTappendOn)
        
        let hitTest = sceneTappendOn.hitTest(touchCoord)
        if hitTest.isEmpty{
            print("not tocuhing")
        }else{
            if countdown > 0{
                let res = hitTest.first!
                print("touched a box ")
                //lab.text = "Pogboom!!👊🏾"
                if res.node.actionKeys.isEmpty{
                    self.imBack()
                    //animate pog
                    SCNTransaction.begin()
                    self.pogimate(node: res.node)
                    SCNTransaction.completionBlock = {
                        //self.lab.text = ""
                        //remove pog
                        res.node.removeFromParentNode()
                        //increment score
                        self.scoreCount += 1
                        self.score.text = "Score: \(self.scoreCount)"
                        // add a new Pogba
                        self.addNode()
                        //restore timer
                        self.restartClock()
                        
                    }
                    SCNTransaction.commit()
                }
            }
        }
    }
    
    //used to add the 3d m0del
    func addNode(){
        let pogba = SCNScene(named: "art.scnassets/pogba2.scn")
        guard let node = pogba?.rootNode.childNode(withName: "pogbs", recursively : false) else {return}
        let pogbaNode = node
        //x y z in metres of world origin
        pogbaNode.position = SCNVector3(GlobalVar.randomNumbers(firstNum: -1, secondNum: 1), GlobalVar.randomNumbers(firstNum: -0.5, secondNum: 0.5), GlobalVar.randomNumbers(firstNum: -1, secondNum: 1))
        //adds the model to the scene
        self.sceneView.scene.rootNode.addChildNode(pogbaNode)
    }
    
    //animate model
    func pogimate(node: SCNNode){
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position
        spin.toValue = SCNVector3(node.presentation.position.x - 0.2 ,node.presentation.position.y - 0.2,node.presentation.position.z - 2)
        spin.duration = 0.7
        spin.repeatCount = 1
        //smooth animate back to current pos
        spin.autoreverses = true
        node.addAnimation(spin, forKey: "position")
    }

    //when the paly boutton is pressed
    @IBAction func pressPlay(_ sender: Any) {
        startGame()
        playBtn.isHidden = true
    }
    
    
    //start game
    
   func startGame(){
        self.setTimer()
        self.addNode()
    }
    //countdown timer
    func setTimer(){
        self.time.perform { () -> NextStep in
            self.countdown -= 1
            self.timer.text = String(self.countdown)
            if self.countdown == 0{
                self.timer.text = ""
                //displays ui alert
                self.gameOverAlert()
                //stops the counter
                return .stop
            }
            return .continue
        }
    }
    
    //restart counter
    func restartClock(){
        self.countdown = 10
        self.timer.text = String(self.countdown)
    }

    //arelt to allow the user to return to the main menu or play again
    func gameOverAlert(){
        //used to create alert apparance
        let appearance = SCLAlertView.SCLAppearance(kCircleIconHeight: 60.0, kTitleFont: UIFont(name: "Premier League", size: 20)!,
                                                    kTextFont: UIFont(name: "Premier League", size: 14)!,
                                                    kButtonFont: UIFont(name: "Premier League", size: 14)!,
                                                    showCloseButton: false, showCircularIcon: true,
                                                    titleColor: UIColor(red: 56.0 / 255.0, green: 0 / 255.0, blue: 60.0 / 255.0, alpha: 1))
        //set the apparence to the alert
        let alert = SCLAlertView(appearance: appearance)
        //add the custom image to the arelt
        let alertViewIcon = UIImage(named: "pog")?.af_imageRounded(withCornerRadius: CGFloat(20.0))
        //add the text to the alert
        alert.showInfo("Game Over", subTitle: "Your Score is \(self.scoreCount)", circleIconImage: alertViewIcon)
        //adds the buttons
        let homeBtn = alert.addButton("Home") {
            //send the user back to the home screen
            self.quitGame()
        }
        
        let againBtn = alert.addButton("Play Again") {
            //restart game
            self.restart()
            //dismiss alert
            alert.dismiss(animated: true, completion: nil)
        }
        //sets tge button styles
        homeBtn.backgroundColor = UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 1)
        homeBtn.titleLabel?.textColor = UIColor(red: 56.0 / 255.0, green: 0 / 255.0, blue: 60.0 / 255.0, alpha: 1)
        againBtn.backgroundColor = UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 1)
        againBtn.titleLabel?.textColor = UIColor(red: 56.0 / 255.0, green: 0 / 255.0, blue: 60.0 / 255.0, alpha: 1)
    }
    
    //play sound
    func imBack(){
        //trys to get the audio rescourse or exits this function
        guard let url = Bundle.main.url(forResource: "imback", withExtension: "mp3") else { return }
        //creates an audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            //gets the player
            guard let player = player else { return }
            //plays the sound
            player.play()
           //catches errors preventing the application crashing
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    //quit game bring user back to menu
    func quitGame(){
        performSegue(withIdentifier: "quitGame", sender: self)
    }
    
    //restart game
    func restart(){
        //reset score
        score.text = "Score: 0"
        scoreCount = 0
        //stop timer
        self.time.stop()
        //restore timer
        self.restartClock()
        //remove missed pogba nodes
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        //restart game
        startGame()
    }
    
    
    
    @IBAction func helpBtn(_ sender: Any) {
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "MiniGameWalkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "MGWalkthrough") as! BWWalkthroughViewController
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController: stb.instantiateViewController(withIdentifier: "mg1"))
        walkthrough.add(viewController: stb.instantiateViewController(withIdentifier: "mg2"))
        walkthrough.add(viewController: stb.instantiateViewController(withIdentifier: "mg3"))
        walkthrough.add(viewController: stb.instantiateViewController(withIdentifier: "mg4"))
        walkthrough.add(viewController: stb.instantiateViewController(withIdentifier: "mg5"))
        walkthrough.add(viewController: stb.instantiateViewController(withIdentifier: "mg6"))
        self.present(walkthrough, animated: true, completion: nil)
        
    }
    
    //close the walktrhough
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
