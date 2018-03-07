//
//  TeamArTest.swift
//  Elite Premier LeagueTests
//
//  Created by JOHN KENNY on 06/03/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import XCTest
@testable import Elite_Premier_League
import AssetsLibrary
import ARKit
import SceneKit


class TeamArTest: XCTestCase {
    
    var vc = TeamsARViewController()
    let lable = UILabel(frame: CGRect())
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //vc.requestTeamData(teamName: "Man Utd")
        lable.text = "John"
        vc.addMenu(team : "Man Utd")
        vc.inforBar = lable
        vc.walkthroughCloseButtonPressed()
        //vc.analyiseImage(image : CVPixelBuffer)
        vc.requestTeamData(teamName: "Man Utd")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInfoBar() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print("he \(vc.inforBar!.text!)")
        XCTAssertTrue(vc.inforBar!.text! == "John")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
