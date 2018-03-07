//
//  TableNodeTest.swift
//  Elite Premier LeagueTests
//
//  Created by JOHN KENNY on 07/03/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import XCTest

@testable import Elite_Premier_League
import UIKit
import SceneKit
import ARKit
import AssetsLibrary
import Pods_Elite_Premier_League


class TableNodeTest: XCTestCase {
    
    var node = TableNode()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        node.setup(newColour: GlobalVar.clear)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testColor() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(node.colour == GlobalVar.clear)
    }
    
    func testTableTop() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(node.tableTop == true)
    }
    
    func testName() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(node.name == "tabelNode")
    }
    
    func testfuncs() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        node.populateTable()
        node.topBar(name: "John")
        node.createTableRow(yPos : 1, tablePos : 1)
        node.changeTable()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
