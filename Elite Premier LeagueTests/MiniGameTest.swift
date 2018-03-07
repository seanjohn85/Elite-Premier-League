//
//  MiniGameTest.swift
//  Elite Premier LeagueTests
//
//  Created by JOHN KENNY on 07/03/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import XCTest

@testable import Elite_Premier_League
import AssetsLibrary
import ARKit
import SceneKit
@testable import Pods_Elite_Premier_League
import AVFoundation

class MiniGameTest: XCTestCase {
    
    let vc = PogbaMiniGameViewController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc.pogimate(node: SCNNode())
        vc.countdown = 7
        vc.walkthroughCloseButtonPressed()
        vc.gameOverAlert()
        vc.imBack()
  
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
