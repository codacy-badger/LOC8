//
//  DirectionTest.swift
//  LOC8Tests
//
//  Created by Marwan Al Masri on 6/1/18.
//  Copyright © 2018 LOC8. All rights reserved.
//

import XCTest

@testable import LOC8

class DirectionTest: LOC8Tests {

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
}
