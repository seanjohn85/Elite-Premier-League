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

class TeamViewController: UIViewController, ARSCNViewDelegate{
    

    @IBOutlet weak var sceneKit: ARSCNView!
     let configuration = ARWorldTrackingConfiguration()
    

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
        
        let node = SCNNode(geometry : SCNPlane(width: 3, height: 2))
        node.geometry?.firstMaterial?.diffuse.contents  = UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 0.8)
        node.position = SCNVector3(0, 0, -5)
        self.sceneKit.scene.rootNode.addChildNode(node)
        
        let node2 = SCNNode(geometry : SCNPlane(width: 0.4, height: 0.4))
        node2.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "\(GlobalVar.currentTeam!.thisName)Crest")
        node2.position = SCNVector3(0, 0, 0.1)
        node.addChildNode(node2)
       
        
        let node3 = SCNNode()
        let label = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0),
                                          width: CGFloat(100), height: CGFloat(50)))
        
        let plane = SCNPlane(width: 0.3, height: 0.2)
        label.textColor = UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 0.8)
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        label.text = GlobalVar.currentTeam!.thisName
        label.adjustsFontSizeToFitWidth = true
        
        plane.firstMaterial?.diffuse.contents = label
        node3.geometry = plane
        node3.position = SCNVector3(0.3, 0.3, 0.1)
        
        //self.sceneKit.scene.rootNode.addChildNode(node)
        
        //node.addChildNode(labelNode)
        
        
        // self.sceneKit.scene.rootNode.addChildNode(labelNode)
        node.addChildNode(node3)
        
        
        let menuNode = SCNNode()
        menuNode.geometry = SCNSphere(radius: 0.2)
        menuNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "\(GlobalVar.currentTeam!.thisName)Texture")
        menuNode.position = SCNVector3(2, 2, -1)
        self.sceneKit.scene.rootNode.addChildNode(menuNode)
        
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degree2Rad), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        menuNode.runAction(forever)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension Int {
    var degree2Rad: Double { return Double(self) * .pi/180}
}
