//
//  GeometryTests.swift
//  LOC8
//
//  Created by Marwan Al Masri on 6/5/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import XCTest

@testable import LOC8

class GeometryTests: XCTestCase {
    
    let accuracyLimit: Int = 1000
    
    // MARK:-
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
    func testRotateFunction() {
        
        for _ in 0...accuracyLimit {
            
            func rotateTest(value: Double, min: Double, max: Double) {
                
                let result = Geometry.rotate(value: value, min: min, max: max)
                if result > max && result < min {
                    XCTFail("Wrong result in value. \nrotate(\(value), min: \(min), max: \(max)) = \(result)")
                }
            }
            
            // Test for Double value.
            func rotateDouble() {
                
                let min = RandomGenerator.double()
                let max = RandomGenerator.double(from: min)
                
                let v_1 = RandomGenerator.double(from: min, to: max)
                let v_2 = RandomGenerator.double(from: max)
                let v_3 = RandomGenerator.double(to: min)
                
                rotateTest(value: v_1, min: min, max: max)
                rotateTest(value: v_2, min: min, max: max)
                rotateTest(value: v_3, min: min, max: max)
            }
            rotateDouble()
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
     Test method that test direction model logic.
     */
    func testDirectionModel() {
        
        for _ in 0...accuracyLimit {
            
            typealias testValue = (direction: Direction, angle: Angle)
        
            func checkDirction(_ zValue: testValue, _ xyValue: testValue, _ isAbsolut: Bool = false) {
                
                // Create direction
                let direction = Direction(theta: zValue.angle.radian, phi: xyValue.angle.radian)
                
                // Check verticale direction [U, D]
                if !direction.contains(zValue.direction) {
                    XCTFail("Direction \(direction) doesn't contains \(zValue.direction) with theta(\(zValue.angle)˚) and phi(\(xyValue.angle)˚).")
                }
                
                // Check horisantel direction [N, NE, E, SE, S, SW, W, NW]
                if isAbsolut {
                    if direction.contains(xyValue.direction) {
                        XCTFail("Direction \(direction) shouldn't contains \(xyValue.direction) with theta(\(zValue.angle)˚) and phi(\(xyValue.angle)˚).")
                    }
                } else if !direction.contains(xyValue.direction) {
                    XCTFail("Direction \(direction) doesn't contains \(xyValue.direction) with theta(\(zValue.angle)˚) and phi(\(xyValue.angle)˚).")
                }
                
                // Logical check
                if (direction.contains(Direction.up) && direction.contains(Direction.down)) ||
                    (direction.contains(Direction.north) && direction.contains(Direction.south)) ||
                    (direction.contains(Direction.east) && direction.contains(Direction.west)) {
                    XCTFail("Direction \(direction) has conflicts.")
                }
            }
            
            func randomAngel(angle: Angle, deference: Angle) -> Angle {
                return RandomGenerator.double(from: angle - deference, to: angle + deference)
            }
            
            // Stub verticale directions
            let absolutUP = (Direction.up, randomAngel(angle:11.25    , deference: 11.25))
            let absolutDown = (Direction.down, randomAngel(angle:168.75  , deference: 11.25))
            
            // Stub horisantel directions
            let xyValues: [testValue] = [(Direction.north, randomAngel(angle:11.25  , deference: 11.25)),
                                         (Direction.east,  randomAngel(angle:90 , deference: 22.5)),
                                         (Direction.south, randomAngel(angle:168.75, deference: 11.25)),
                                         (Direction.west,  randomAngel(angle:-90, deference: 22.5)),
                                         
                                         ([Direction.north, Direction.east], randomAngel(angle:45 , deference: 22.5)),
                                         ([Direction.south, Direction.east], randomAngel(angle:135, deference: 22.5)),
                                         ([Direction.south, Direction.west], randomAngel(angle:-135, deference: 22.5)),
                                         ([Direction.north, Direction.west], randomAngel(angle:-45, deference: 22.5))]
            
            // Stub in between diractions
            let zValues: [testValue] = [(Direction.up,   randomAngel(angle:45   , deference: 22.5)),
                                        (Direction.none, randomAngel(angle:90   , deference: 22.5)),
                                        (Direction.down, randomAngel(angle:135  , deference: 22.5))]
            
            
            for xyValue in xyValues {
                checkDirction(absolutUP, xyValue, true)
                checkDirction(absolutDown, xyValue, true)
                for zValue in zValues {
                    checkDirction(zValue, xyValue)
                }
            }
            
        }
    }
    
    /*
     Test method that test Vector3D model logic.
     */
    func testVector3DModel() {
        
        for _ in 0...accuracyLimit {
            
            let vector = RandomGenerator.vector()
            let cartesian_1 = vector.cartesianVector
            let spherical_1 = vector.sphericalVector
            let cylindrical_1 = vector.cylindricalVector
            
            // spherical to cartesian
            let cartesian_2 = spherical_1.cartesianVector
            
            if round(cartesian_1.x) != round(cartesian_2.x) ||
               round(cartesian_1.y) != round(cartesian_2.y) ||
               round(cartesian_1.z) != round(cartesian_2.z) {
                XCTFail("Error in converting spherical to cartesian in vector:\n\(vector) \norigenal cartesian:  \(cartesian_1) \nconverted cartesian: \(cartesian_2) \n")
            }
            
            // Cartesian to spherical
            let spherical_2 = cartesian_1.sphericalVector
            
            if round(spherical_1.radial) != round(spherical_2.radial) ||
               round(spherical_1.theta)  != round(spherical_2.theta)  ||
               round(spherical_1.phi)    != round(spherical_2.phi)    {
                XCTFail("Error in converting cartesian to spherical in vector:\n\(vector) \norigenal spherical:  \(spherical_1) \nconverted spherical: \(spherical_2) \n")
            }
            
            // Cylindrical to cartesian
            let cartesian_3 = cylindrical_1.cartesianVector
            
            if round(cartesian_1.x) != round(cartesian_3.x) ||
               round(cartesian_1.y) != round(cartesian_3.y) ||
               round(cartesian_1.z) != round(cartesian_3.z) {
                XCTFail("Error in converting cylindrica to cartesian in vector:\n\(vector) \norigenal cartesian:  \(cartesian_1) \nconverted cartesian: \(cartesian_3) \n")
            }
            
            // Cartesian to cylindrica
            let cylindrical_2 = cartesian_1.cylindricalVector
            
            if round(cylindrical_1.rho)    != round(cylindrical_2.rho)    ||
               round(cylindrical_1.height) != round(cylindrical_2.height) ||
               round(cylindrical_1.phi)    != round(cylindrical_2.phi)    {
                XCTFail("Error in converting cartesian to cylindrical in vector:\n\(vector) \norigenal cylindrical:  \(cylindrical_1) \nconverted cylindrical: \(cylindrical_2) \n")
            }
            
            // Cylindrica to spherical
            let spherical_3 = cylindrical_1.sphericalVector
            
            if round(spherical_1.radial) != round(spherical_3.radial) ||
               round(spherical_1.theta)  != round(spherical_3.theta)  ||
               round(spherical_1.phi)    != round(spherical_3.phi)    {
                XCTFail("Error in converting cylindrica to spherical in vector:\n\(vector) \norigenal spherical:  \(spherical_1) \nconverted spherical: \(spherical_3) \n")
            }
            
            // spherical to cylindrica
            let cylindrical_3 = spherical_1.cylindricalVector
            
            if round(cylindrical_1.rho)    != round(cylindrical_3.rho)    ||
               round(cylindrical_1.height) != round(cylindrical_3.height) ||
               round(cylindrical_1.phi)    != round(cylindrical_3.phi)    {
                XCTFail("Error in converting spherical to cylindrical in vector:\n\(vector) \norigenal cylindrical:  \(cylindrical_1) \nconverted cylindrical: \(cylindrical_3) \n")
            }
        }
    }
}
