//
//  MenuNodeTest.swift
//  Elite Premier LeagueTests
//
//  Created by JOHN KENNY on 06/03/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import XCTest
@testable import Elite_Premier_League
import UIKit
import SceneKit
import ARKit

class MenuNodeTest: XCTestCase {
    var menu = MenuNode(geometry : SCNSphere(radius: 0.4))
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        menu.setUp(imageName : "Man Utd")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMenuName() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(menu.name == "menu")

    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
