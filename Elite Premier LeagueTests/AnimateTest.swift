//
//  AnimateTest.swift
//  Elite Premier LeagueTests
//
//  Created by JOHN KENNY on 07/03/2018.
//  Copyright © 2018 JOHN KENNY. All rights reserved.
//

import XCTest

@testable import Elite_Premier_League
@testable import Pods_Elite_Premier_League



class AnimateTest: XCTestCase {
    let lable = UILabel(frame: CGRect())
    let avc = AnimateViewController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        lable.text = "animate"
        avc.viewDidLoad()
        avc.titleLab = lable
        avc.subText = lable
        avc.walkthroughDidScroll(to: 1.2, offset: 12.3)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLables() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(avc.subText!.text! == "animate")
        XCTAssertTrue(avc.titleLab!.text! == "animate")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
