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
    
    let accuracyLimit: Int = 100
    
    //MARK:- Tests
    
    /*
     Test method that test clamp function logic.
     */
    func testClampFunction() {
        
        for _ in 0...accuracyLimit {
            
            func clampTest<T: Comparable>(min: T, max: T, v_1: T, v_2: T, v_3: T) {
                
                let r_1 = clamp(value: v_1, min: min, max: max)
                if r_1 != v_1 {
                    XCTFail("Wrong result in \(T.self). \ncase [min < v < max] \nclamp(\(v_1), min: \(min), max: \(max)) = \(r_1)")
                }
                
                let r_2 = clamp(value: v_2, min: min, max: max)
                if r_2 != max {
                    XCTFail("Wrong result in \(T.self). \ncase [min < max < v] \nclamp(\(v_2), min: \(min), max: \(max)) = \(r_2)")
                }
                
                let r_3 = clamp(value: v_3, min: min, max: max)
                if r_3 != min {
                    XCTFail("Wrong result in \(T.self). \ncase [v < min < max] \nclamp(\(v_3), min: \(min), max: \(max)) = \(r_3)")
                }
                
                let r_4 = clamp(value: v_1, min: min, max: min)
                if r_4 != min {
                    XCTFail("Wrong result in \(T.self). \ncase [min == max] \nclamp(\(v_1), min: \(min), max: \(min)) = \(r_4)")
                }
                
                let r_5 = clamp(value: v_1, min: max, max: min)
                if r_5 != v_1 {
                    XCTFail("Wrong result in \(T.self). \ncase [max < min] \nclamp(\(v_1), min: \(max), max: \(min)) = \(r_5)")
                }
            }
            
            //Test for Integer value.
            func clampInteger() {
                
                let min = RandomGenerator.integer()
                let max = RandomGenerator.integer(from: min)
                
                let v_1 = RandomGenerator.integer(from: min, to: max)
                let v_2 = RandomGenerator.integer(from: max)
                let v_3 = RandomGenerator.integer(to: min)
                
                clampTest(min: min, max: max, v_1: v_1, v_2: v_2, v_3: v_3)
            }
            clampInteger()
            
            //Test for Float value.
            func clampFloat() {
                
                let min = RandomGenerator.float()
                let max = RandomGenerator.float(from: min)
                
                let v_1 = RandomGenerator.float(from: min, to: max)
                let v_2 = RandomGenerator.float(from: max)
                let v_3 = RandomGenerator.float(to: min)
                
                clampTest(min: min, max: max, v_1: v_1, v_2: v_2, v_3: v_3)
            }
            clampFloat()
            
            //Test for Double value.
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
                
                let result = rotate(value: value, min: min, max: max)
                if result > max && result < min {
                    XCTFail("Wrong result in value. \nrotate(\(value), min: \(min), max: \(max)) = \(result)")
                }
            }
            
            //Test for Double value.
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
                
                let result = wrap(value)
                if result > 1 && result < 0 {
                    XCTFail("Wrong result in value. \nwrap(\(value)) = \(result)")
                }
            }
            
            //Test for Double value.
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
        
        return
        
        for _ in 0...accuracyLimit {
        
            //Stub horisantel direction [N, NE, E, SE, S, SW, W, NW]
            let xyValues: [(direction: Direction, angle: Angle)] =
                [
                    (Direction.north, RandomGenerator.angel(angle:0  , deference: 22.5)),
                    (Direction.east,  RandomGenerator.angel(angle:90 , deference: 22.5)),
                    (Direction.south, RandomGenerator.angel(angle:180, deference: 22.5)),
                    (Direction.west,  RandomGenerator.angel(angle:270, deference: 22.5)),
                    
                    ([Direction.north, Direction.east], RandomGenerator.angel(angle:45 , deference: 22.5)),
                    ([Direction.south, Direction.east], RandomGenerator.angel(angle:135, deference: 22.5)),
                    ([Direction.south, Direction.west], RandomGenerator.angel(angle:225, deference: 22.5)),
                    ([Direction.north, Direction.west], RandomGenerator.angel(angle:315, deference: 22.5))
                ]
            
            //Stub verticale direction [U, D]
            let zValues: [(direction: Direction, angle: Angle)] =
                [
                    (Direction.none, RandomGenerator.angel(angle:90 , deference: 45)),
                    (Direction.up,   RandomGenerator.angel(angle:0  , deference: 45)),
                    (Direction.down, RandomGenerator.angel(angle:180, deference: 45)),
                    (Direction.none, RandomGenerator.angel(angle:270, deference: 45))
                ]
            
            for zValue in zValues {
                
                for xyValue in xyValues {
                    
                    //Create direction
                    let direction = Direction(theta: xyValue.angle, lambda: zValue.angle)
                    
                    //check verticale direction [U, D]
                    if !direction.contains(zValue.direction) {
                        XCTFail("Direction \(direction.description) doesn't contains \(zValue.direction.description) with lambda(\(zValue.angle.degree)˚).")
                    }
                    
                    //check horisantel direction [N, NE, E, SE, S, SW, W, NW]
                    if !direction.contains(xyValue.direction) {
                        XCTFail("Direction \(direction.description) doesn't contains \(xyValue.direction.description)with theta(\(xyValue.angle.degree)˚).")
                    }
                    
                    //Logical check
                    if (direction.contains(Direction.up) && direction.contains(Direction.down)) ||
                    (direction.contains(Direction.north) && direction.contains(Direction.south)) ||
                     (direction.contains(Direction.east) && direction.contains(Direction.west)) {
                        XCTFail("Direction \(direction) has conflicts.")
                    }
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
            
            let cartesian_1 = vector.cartesianVector!
            
            let polar_1 = vector.polarVector!
            
            let cartesian_2 = polar_1.cartesianVector
            
            let polar_2 = cartesian_1.polarVector
            
            if round(cartesian_1.x) != round(cartesian_2.x) ||
               round(cartesian_1.y) != round(cartesian_2.y) ||
               round(cartesian_1.z) != round(cartesian_2.z) {
                XCTFail("Error in converting poler to cartesian in vector:\n\(vector.description) \norigenal cartesian:  \(cartesian_1.description) \nconverted cartesian: \(cartesian_2.description) \n\n\norigenal poler:  \(polar_1.description) \nconverted poler: \(polar_2.description) \n")
                
            }
            
            if polar_1.magnitude != polar_2.magnitude ||
               polar_1.theta     != polar_2.theta     ||
               polar_1.lambda    != polar_2.lambda {
                XCTFail("Error in converting cartesian to poler in vector:\n\(vector.description) \norigenal cartesian:  \(cartesian_1.description) \nconverted cartesian: \(cartesian_2.description) \n\n\norigenal poler:  \(polar_1.description) \nconverted poler: \(polar_2.description) \n")
                
            }
        }
    }
    
    /*
     Test method that test Rotation3D model logic.
     */
    func testRotation3DModel() {
        for _ in 0...accuracyLimit {
            
            let rotation = RandomGenerator.rotation()
            
            let euler_1 = rotation.eulerAngles!
            
            let matrix_1 = rotation.rotationMatrix!
            
            let quaternion_1 = rotation.quaternion!
            
            let euler_2 = matrix_1.eulerAngles
            
            let matrix_2 = euler_1.rotationMatrix
            
//            let quaternion_2 = euler_1.quaternion
//
//            let matrix_3 = quaternion_1.rotationMatrix
//            
//            let euler_3 = quaternion_1.eulerAngles
//            
//            let quaternion_3 = matrix_1.quaternion
            
            
//            if euler_1.yaw   != euler_2.yaw   ||
//               euler_1.pitch != euler_2.pitch ||
//               euler_1.roll  != euler_2.roll {
//                XCTFail("Error in converting rotation matrix to euler angles in rotation:\n\(rotation.description) \norigenal euler angles:  \(euler_1.description) \nconverted euler angles: \(euler_2.description) \n\n\norigenal rotation matrix:  \(matrix_1.description) \nconverted rotation matrix: \(matrix_2.description) \n")
//
//            }
            
            
            if matrix_1.m11 != matrix_2.m11 ||
               matrix_1.m12 != matrix_2.m12 ||
               matrix_1.m13 != matrix_2.m13 ||
               matrix_1.m21 != matrix_2.m21 ||
               matrix_1.m22 != matrix_2.m22 ||
               matrix_1.m23 != matrix_2.m23 ||
               matrix_1.m31 != matrix_2.m31 ||
               matrix_1.m32 != matrix_2.m32 ||
               matrix_1.m33 != matrix_2.m33 {
                XCTFail("Error in converting euler angles to rotation matrix in rotation:\n\(rotation.description) \norigenal euler angles:  \(euler_1.description) \nconverted euler angles: \(euler_2.description) \n\n\norigenal rotation matrix:  \(matrix_1.description) \nconverted rotation matrix: \(matrix_2.description) \n")
                
            }

        }
    }
}
