//
//  GeometryTests.swift
//  LOC8
//
//  Created by Marwan Al Masri on 6/5/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import XCTest

@testable import LOC8

class GeometryTests: LOC8Tests {
    
    // MARK: Tests
    
    /*
     Test method that test clamp function logic.
     */
    func testClampFunction() {
        
        for _ in 0...accuracyLimit {
            
            func clampTest<T: Comparable>(min: T, max: T, v_1: T, v_2: T, v_3: T) {
                
                let r_1 = Geometry.clamp(value: v_1, min: min, max: max)
                if r_1 != v_1 {
                    XCTFail("Wrong result in \(T.self). \ncase [min < v < max] \nclamp(\(v_1), min: \(min), max: \(max)) = \(r_1)")
                }
                
                let r_2 = Geometry.clamp(value: v_2, min: min, max: max)
                if r_2 != max {
                    XCTFail("Wrong result in \(T.self). \ncase [min < max < v] \nclamp(\(v_2), min: \(min), max: \(max)) = \(r_2)")
                }
                
                let r_3 = Geometry.clamp(value: v_3, min: min, max: max)
                if r_3 != min {
                    XCTFail("Wrong result in \(T.self). \ncase [v < min < max] \nclamp(\(v_3), min: \(min), max: \(max)) = \(r_3)")
                }
                
                let r_4 = Geometry.clamp(value: v_1, min: min, max: min)
                if r_4 != min {
                    XCTFail("Wrong result in \(T.self). \ncase [min == max] \nclamp(\(v_1), min: \(min), max: \(min)) = \(r_4)")
                }
                
                let r_5 = Geometry.clamp(value: v_1, min: max, max: min)
                if r_5 != v_1 {
                    XCTFail("Wrong result in \(T.self). \ncase [max < min] \nclamp(\(v_1), min: \(max), max: \(min)) = \(r_5)")
                }
            }
            
            // Test for Integer value.
            func clampInteger() {
                
                let min = RandomGenerator.integer()
                let max = RandomGenerator.integer(from: min)
                
                let v_1 = RandomGenerator.integer(from: min, to: max)
                let v_2 = RandomGenerator.integer(from: max)
                let v_3 = RandomGenerator.integer(to: min)
                
                clampTest(min: min, max: max, v_1: v_1, v_2: v_2, v_3: v_3)
            }
            clampInteger()
            
            // Test for Float value.
            func clampFloat() {
                
                let min = RandomGenerator.float()
                let max = RandomGenerator.float(from: min)
                
                let v_1 = RandomGenerator.float(from: min, to: max)
                let v_2 = RandomGenerator.float(from: max)
                let v_3 = RandomGenerator.float(to: min)
                
                clampTest(min: min, max: max, v_1: v_1, v_2: v_2, v_3: v_3)
            }
            
            // Test for Double value.
            func clampDouble() {
                
                let min = RandomGenerator.double()
                let max = RandomGenerator.double(from: min)
                
                let v_1 = RandomGenerator.double(from: min, to: max)
                let v_2 = RandomGenerator.double(from: max)
                let v_3 = RandomGenerator.double(to: min)
                
                clampTest(min: min, max: max, v_1: v_1, v_2: v_2, v_3: v_3)
            }
            clampDouble()
        }
    }
    
    /*
     Test method that test clamp function logic.
     */
    func testWrapFunction() {
        
        for _ in 0...accuracyLimit {
            
            func wrapTest(value: Double) {
                
                let result = Geometry.wrap(value)
                if result > 1 && result < 0 {
                    XCTFail("Wrong result in value. \nwrap(\(value)) = \(result)")
                }
            }
            
            // Test for Double value.
            func wrapDouble() {
                
                let min = RandomGenerator.double()
                let max = RandomGenerator.double(from: min)
                
                let v_1 = RandomGenerator.double(from: min, to: max)
                let v_2 = RandomGenerator.double(from: max)
                let v_3 = RandomGenerator.double(to: min)
                
                wrapTest(value: v_1)
                wrapTest(value: v_2)
                wrapTest(value: v_3)
            }
            wrapDouble()
        }
    }
    
    /*
     Test method that test clamp function logic.
     */
    func testRotateFunction() {
        
        for _ in 0...accuracyLimit {
            
            func rotateTest(value: Double, min: Double, max: Double) {
                
                let result = Geometry.rotate(value: value, min: min, max: max)
                if result > max && result < min {
                    XCTFail("Wrong result in value. \nrotate(\(value), min: \(min), max: \(max)) = \(result)")
                }
            }
            
            let min = RandomGenerator.double()
            let max = RandomGenerator.double(from: min)
            
            let v_1 = RandomGenerator.double(from: min, to: max)
            let v_2 = RandomGenerator.double(from: max)
            let v_3 = RandomGenerator.double(to: min)
            
            rotateTest(value: v_1, min: min, max: max)
            rotateTest(value: v_2, min: min, max: max)
            rotateTest(value: v_3, min: min, max: max)
        }
    }
    
    /*
     Test method that test clamp function logic.
     */
    func testTruncateFunction() {
        
        // test positive number
        let value = 3.14159265
        let decimalPlaces = UInt(4)
        let trueValue = 3.1415
        
        var result = Geometry.truncate(value: value, decimalPlaces: decimalPlaces)
        
        if result != trueValue {
            XCTFail("Wrong result in value. \ntruncate(\(value), decimalPlaces: \(decimalPlaces)) = \(result). it should be \(trueValue)")
        }
        
        // test nigative number
        
        result = Geometry.truncate(value: -value, decimalPlaces: decimalPlaces)
        
        if result != -trueValue {
            XCTFail("Wrong result in value. \ntruncate(\(-value), decimalPlaces: \(decimalPlaces)) = \(result). it should be \(-trueValue)")
        }
    }
}
