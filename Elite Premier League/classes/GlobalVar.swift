//
//  GlobalVar.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 30/01/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SceneKit

struct GlobalVar{
    
    
    //this needs to be changed to access http://192.168.0.157:8080/
    static let serverAddress = "http://192.168.0.157:8080/"
    //where the player images are located on the server
    static let teamData = "\(serverAddress)rest/getData/"
    ///when a team is regonised it will be stored here
    static var currentTeam : Team?
    //to get images from the server
    static let imagesUrl = "\(serverAddress)static/images/"
    //no longer used
    static let tabelURL = "https://heisenbug-premier-league-live-scores-v1.p.mashape.com/api/premierleague/table?from=1"
    static let TableHeaders : HTTPHeaders = [ "X-Mashape-Key": "bNe6srfQEGmshYAZN1azDXN2CVd7p1jhiO0jsnwZZ35npf4gyK",
                                  "Accept": "application/json"]
    
    //colours
    static let clear = UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 133.0 / 255.0, alpha: 0)
    
    
    //global methods used in the project by different classes
    
    //converts an image to a node with the image as a texture
    static func addImage(imageName : String, x : Double, y : Double) -> SCNNode{
        //crests a new node
        let imageNode = SCNNode(geometry : SCNPlane(width: 0.7, height: 0.7))
        //appends the crest image to the node palne
        imageNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "\(imageName)Crest")
        //positions the crest using the given the x and y pos prams
        imageNode.position = SCNVector3(x, y, 0.1)
        return imageNode
        
    }
    
    //converts an image to a node with the image as a texture
    static func addImage(image : UIImage, w : Double, h : Double, x : Double, y : Double) -> SCNNode{
        //creates a new node
        let imageNode = SCNNode(geometry : SCNPlane(width: CGFloat(w), height: CGFloat(h)))
        //appends the crest image to the node palne
        imageNode.geometry?.firstMaterial?.diffuse.contents = image
        //positions the crest using the given the x and y pos prams
        imageNode.position = SCNVector3(x, y, 0.1)
        return imageNode
        
    }
    
    //converts a view to an image
    static func convertViewToImage(view : UIView) -> UIImage{
        //converts the view to a UIIMage
        UIGraphicsBeginImageContext(view.frame.size)
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //returns a ui image created from the view
        return image!
    }
    //generate a random number
    static func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
}

