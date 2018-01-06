//
//  NumericalIntegrationTest.swift
//  LOC8Tests
//
//  Created by Marwan Al Masri on 6/1/18.
//  Copyright © 2018 LOC8. All rights reserved.
//

import XCTest

@testable import LOC8

class NumericalIntegrationTest: LOC8Tests {
    
    /// A type represent data (x, y) for numerical integraton and the true integral (i)
    typealias TestData = (set: [Double], dx: Double, i: Double)
    
    /**
     Generating a test data set with trigonometric function.
     
     The data is genrated using the function
     
     __ƒ(x) = cos(x)__
     
     where __x ∈ [-π, +π]__ and __y ∈ [-1, +1]__
     
     and the integral of __ƒ(x)__ is:
     
     __∫ cos(x) dx = sin(x) + c__
     
     where __dx = 1/10__
     
     */
    var trigonometricTastData: TestData {
        
        let d = 10.0
        
        let start = Int(-Double.pi * d) // -π
        let end = Int(Double.pi * d)    // +π
        
        let x0 = Double(start) / d
        let xn = Double(end) / d
        let i = sin(xn) - sin(x0) // F(xn) - F(x0)
        
        var data: TestData = ([], dx: 1 / d, i: i)
        
        for v in start...end {
            let x = Double(v) / d
            let y = cos(x)
            data.set.append(y)
        }
        
        return data
    }
    
    /**
     Generating a test data set with polynomial function.
     
     The data is genrated using the function
     
     __ƒ(x) = 2x__
     
     where __x ∈ [-10, +10]__ and __y ∈ [-∞, +∞]__
     
     and the integral of __ƒ(x)__ is:
     
     __∫ 2x dx = x² + c__
     
     where __dx = 1/10__
     
     */
    var polynomialTastData: TestData {
        
        let d = 10.0
        
        let start = Int(-10.0 * d) // -10
        let end = Int(10.0 * d)    // +10
        
        let x0 = Double(start) / d
        let xn = Double(end) / d
        let i = pow(xn, 2) - pow(x0, 2) // F(xn) - F(x0)
        
        var data: TestData = ([], dx: 1 / d, i: i)
        
        for v in start...end {
            let x = Double(v) / d
            let y = 2 * x
            data.set.append(y)
        }
        
        return data
    }
    
    /**
     Generating a test data set with exponential function.
     
     The data is genrated using the function
     
     __ƒ(x) = eˣ__
     
     where __x ∈ [-10, +10]__ and __y ∈ [-∞, +∞]__
     
     and the integral of __ƒ(x)__ is:
     
     __∫ eˣ dx = eˣ + c__
     
     where __dx = 1/10__
     
     */
    var exponentialTastData: TestData {
        
        let d = 10.0
        
        let start = Int(-10.0 * d) // -10
        let end = Int(10.0 * d)    // +10
        
        let x0 = Double(start) / d
        let xn = Double(end) / d
        let i = exp(xn) - exp(x0) // F(xn) - F(x0)
        
        var data: TestData = ([], dx: 1 / d, i: i)
        
        for v in start...end {
            let x = Double(v) / d
            let y = exp(x)
            data.set.append(y)
        }
        
        return data
    }
    
    /**
     Generating a test data set with logarithmic function.
     
     The data is genrated using the function
     
     __ƒ(x) = ln(x)__
     
     where __x ∈ [1.0, +10]__ and __y ∈ [-∞, +∞]__
     
     and the integral of __ƒ(x)__ is:
     
     __∫ ln(x) dx = x ln(x) - x + c__
     
     where __dx = 1/10__
     
     */
    var logarithmicTastData: TestData {
        
        let d = 10.0
        
        let start = Int(1.0 * d) // 0
        let end = Int(10.0 * d)  // 10
        
        let x0 = Double(start) / d
        let xn = Double(end) / d
        let i = (xn * log(xn) - xn) - (x0 * log(x0) - x0) // F(xn) - F(x0)
        
        var data: TestData = ([], dx: 1 / d, i: i)
        
        for v in start...end {
            let x = Double(v) / d
            let y = log(x)
            data.set.append(y)
        }
        
        return data
    }

    func testRectangularLeft() {
        
        func test(data: TestData) {
            let approximat = NumericalIntegration.rectangularLeft(set: data.set, dx: data.dx)
            if round(approximat) != round(data.i) {
                XCTFail("Wrong result in value \(data.i) ≠ \(approximat)")
            }
        }
        
        test(data: self.trigonometricTastData)
        
    }
    
    func testRectangularRightt() {
        
        func test(data: TestData) {
            let approximat = NumericalIntegration.rectangularRight(set: data.set, dx: data.dx)
            if round(approximat) != round(data.i) {
                XCTFail("Wrong result in value \(data.i) ≠ \(approximat)")
            }
        }
        
        test(data: self.trigonometricTastData)
    }
    
    func testTrapezoidal() {
        
        func test(data: TestData) {
            let approximat = NumericalIntegration.trapezoidal(set: data.set, dx: data.dx)
            if round(approximat) != round(data.i) {
                XCTFail("Wrong result in value \(data.i) ≠ \(approximat)")
            }
        }
        
        test(data: self.trigonometricTastData)
        test(data: self.polynomialTastData)
    }
    
    func testSimpsons() {
        
        func test(data: TestData) {
            let approximat = NumericalIntegration.simpsons(set: data.set, dx: data.dx)
            if round(approximat) != round(data.i) {
                XCTFail("Wrong result in value \(data.i) ≠ \(approximat)")
            }
        }
        
        test(data: self.trigonometricTastData)
        test(data: self.polynomialTastData)
        test(data: self.exponentialTastData)
        test(data: self.logarithmicTastData)
    }
}
