//
//  AngelTest.swift
//  LOC8Tests
//
//  Created by Marwan Al Masri on 6/1/18.
//  Copyright © 2018 LOC8. All rights reserved.
//

import XCTest

@testable import LOC8

class AngelTest: LOC8Tests {

    /*
     Test method that test Angle model logic.
     */
    func testAngel() {
        
        for _ in 0...accuracyLimit {
            let degree = RandomGenerator.angel()
            let radian = degree.radian
            let degree2 = radian.degree
            let radian2 = degree2.radian
            
            if round(degree) != round(degree2) {
                XCTFail("Error in converting radian to degree for [\(degree)º, \(degree2)º] with [\(radian)] in radian")
            }
            
            if round(radian) != round(radian2) {
                XCTFail("Error in converting degree to radian for [\(radian), \(radian2)] in radian with [\(degree2)]")
            }
        }
    }
}
