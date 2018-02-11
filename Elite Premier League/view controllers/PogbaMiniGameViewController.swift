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

class PogbaMiniGameViewController: UIViewController, ARSCNViewDelegate  {
    
    @IBOutlet var sceneView: ARSCNView!
    
    
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //when the paly boutton is pressed
    @IBAction func pressPlay(_ sender: Any) {
        
        
    }
    
    
    


}
