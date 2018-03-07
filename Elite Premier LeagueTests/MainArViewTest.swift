//
//  MainArViewTest.swift
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


class MainArViewTest: XCTestCase {
    
    var main = MainScreenViewController()
    let imageV = UIImageView()
    let lable = UILabel(frame: CGRect())
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //set the iamgeview
        imageV.image = #imageLiteral(resourceName: "Man UtdCrest")
        lable.text = "test"
        main.imageView = imageV
        main.team1 = lable
        main.team2 = lable
        main.team3 = lable
        main.displayName(text : "test")
        main.walkthroughCloseButtonPressed() 
        main.populateLabels(name: "Test", pos : 1)
        main.populateLabels(name: "Test", pos : 2)
        main.populateLabels(name: "Test", pos : 3)
   
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testImage () {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(main.imageView == imageV)
    }
    func testA(){
        //main.helpBtn(UIControlEvents.touchUpInside)
        
    }
    
    func testLables () {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(main.team1 == lable)
        XCTAssertTrue(main.team2 == lable)
        XCTAssertTrue(main.team3 == lable)
    }
    

    func testCreateNode(){
        let node =  main.createTextNode(text : "test")
        XCTAssertTrue(((node as? SCNNode) != nil))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
