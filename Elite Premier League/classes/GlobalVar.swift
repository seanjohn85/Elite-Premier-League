//
//  GlobalVar.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 30/01/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import Foundation
struct GlobalVar{
    //this needs to be changed to acess
    static let serverAddress = "http://192.168.0.158:8000/rest/"
    //where the player images are located on the server
    static let imagesDir = ""
    ///when a team is regonised it will be stored here
    static var currentTeam : Team?
    
    static let imagesUrl = "http://192.168.0.157:8080/static/images/"
}

