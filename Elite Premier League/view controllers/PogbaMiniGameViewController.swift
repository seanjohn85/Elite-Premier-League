//
//  PogbaMiniGameViewController.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 06/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit
import ARKit

class PogbaMiniGameViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    //sets the AR configuration
    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
