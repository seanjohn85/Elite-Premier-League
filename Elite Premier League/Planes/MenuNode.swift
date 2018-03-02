//
//  Menu.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 21/02/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MenuNode: SCNNode {
    

    init(geometry: SCNGeometry) {
        super.init()
        self.geometry = geometry
        //animates the node
        animate()
    }
    
    // SCNNode objects require this 
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //adds the image texture to the menu
    func setUp(imageName : String){
        //menuNode.geometry = SCNSphere(radius: 0.1)
        self.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "\(imageName)Texture")
        //positions the node in real world using x y z axis in meters
        self.position = SCNVector3(-1.5, 1.5, 0.1)
        //used to indentify this node as a menu when a user touches it
        self.name = "menu"
    }
    
    //animates the menu 360 
    private func animate(){
        //creates a 360 degree roatation that lasts for 8 seconds
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degree2Rad), z: 0, duration: 8)
        //loops the rotation to repeat
        let forever = SCNAction.repeatForever(action)
        //adds the roatation animation to the menu node
        self.runAction(forever)
    }
    
}

