//
//  GlobalVar.swift
//  Elite Premier League
//
//  Created by JOHN KENNY on 30/01/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import Foundation
import Alamofire

struct GlobalVar{
    //this needs to be changed to acess
    static let serverAddress = "http://192.168.0.157:8080/"
    //where the player images are located on the server
    static let teamData = "\(serverAddress)rest/getData/"
    ///when a team is regonised it will be stored here
    static var currentTeam : Team?
    
    static let imagesUrl = "\(serverAddress)static/images/"
    
    static let tabelURL = "https://heisenbug-premier-league-live-scores-v1.p.mashape.com/api/premierleague/table?from=1"
    static let TableHeaders : HTTPHeaders = [ "X-Mashape-Key": "bNe6srfQEGmshYAZN1azDXN2CVd7p1jhiO0jsnwZZ35npf4gyK",
                                  "Accept": "application/json"]
    
}

