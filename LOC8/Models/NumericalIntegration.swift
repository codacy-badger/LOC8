//
//  NumericalIntegration.swift
//  LOC8
//
//  Created by Marwan Al Masri on 6/1/18.
//  Copyright © 2018 LOC8. All rights reserved.
//

import Foundation

/**
 ### Discussion
 Numerical integration is a way to approximate the definite integral of a function. It is useful in two
 circumstances:
 
 1. if we do not know the formula for the function, but only a table of values or a graph
 2. if an antiderivative of the integrand is unknown
 
 - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Numerical_integration)
 */
public class NumericalIntegration {
    
    /**
     Calculate the integral of a data set over a sampling deferance using __left Riemann sum__.
     
     ### Discussion
     For the left Riemann sum, approximating the function by its value at the left-end point gives multiple rectangles with base __Δx__ and height __f(a + iΔx)__. Doing this for __i = 0, 1, ..., n − 1__, and adding up the resulting areas produces
     
     ![Equation](https://latex.codecogs.com/png.latex?%5Cint_a%5Eb%20f%28x%29%20%5C%2C%20dx%20%5Capprox%20%5Csum_%7Bi%3D1%7D%5E%7Bn%7D%20%5C%20%5CDelta%20x%20f%28x_i%29)
     
     - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Riemann_sum)
     
     - Parameter set: represent the data set for the integration.
     - Parameter dx: represent the sampling deferance of the data set.
     
     - Returns: the intrgral of the data set provided over the sampling deferance.
     */
    public static func rectangularLeft(set: [Double], dx: Double) -> Double {
        
        // Insanaty check
        if set.count <= 1 {
            return 0
        }
        
        var accumulator: Double = 0.0
        
        for i in 0..<(set.count - 1) {
            let x = set[i]
            accumulator += x * dx
        }
        
        return accumulator
    }
    
    /**
     Calculate the integral of a data set over a sampling deferance using __right Riemann sum__
     
     ### Discussion
     For the right Riemann sum, approximating the function by its value at the right-end point gives multiple rectangles with base __Δx__ and height __f(a + iΔx)__. Doing this for __i = 1, ..., n__, and adding up the resulting areas produces
     
     ![Equation](https://latex.codecogs.com/png.latex?%5Cint_a%5Eb%20f%28x%29%20%5C%2C%20dx%20%5Capprox%20%5Csum_%7Bi%3D0%7D%5E%7Bn-1%7D%20%5C%20%5CDelta%20x%20f%28x_i%29)
     
     - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Riemann_sum)
     
     - Parameter set: represent the data set for the integration.
     - Parameter dx: represent the sampling deferance of the data set.
     
     - Returns: the intrgral of the data set provided over the sampling deferance.
     */
    public static func rectangularRight(set: [Double], dx: Double) -> Double {
        
        // Insanaty check
        if set.count <= 1 {
            return 0
        }
        
        var accumulator: Double = 0.0
        
        for i in 1..<set.count {
            let x = set[i]
            accumulator += x * dx
        }
        
        return accumulator
    }
    
    /**
     Calculate the integral of a data set over a sampling deferance using __trapezoidal rule__
     
     ### Discussion
     The trapezoidal rule viewed as the result obtained by averaging the left and right Riemann sums,
     it's defined as the following:
     
     ![Equation](https://latex.codecogs.com/png.latex?%5Cint_a%5Eb%20f%28x%29%20%5C%2C%20dx%20%5Capprox%20%5Csum_%7Bi%3D1%7D%5En%20%5Cfrac%7Bf%28x_%7Bi-1%7D%29&plus;f%28x_i%29%7D%7B2%7D%5C%20%5CDelta%20x_i)
     
     - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Trapezoidal_rule)
     
     - Parameter set: represent the data set for the integration.
     - Parameter dx: represent the sampling deferance of the data set.
     
     - Returns: the intrgral of the data set provided over the sampling deferance.
     */
    public static func trapezoidal(set: [Double], dx: Double) -> Double {
        
        // Insanaty check
        if set.count <= 1 {
            return 0
        }
        
        var accumulator: Double = 0.0
        
        for i in 0..<(set.count - 1) {
            let a = set[i]
            let b = set[i + 1]
            accumulator += ((a + b) / 2) * dx
        }
        
        return accumulator
    }
    
    /**
     Calculate the integral of a data set over a sampling deferance using __simpson’s rule__
     
     ### Discussion
     Simpson’s rule is obtained by interpolating the function between the table of values by a piecewise
     quadratic function, for points that are equally spaced
     
     ![Equation](https://latex.codecogs.com/png.latex?%5Cint_a%5Eb%20f%28x%29%20%5C%2C%20dx%5Capprox%5Ctfrac%7Bh%7D%7B3%7D%20%5Cbigg%5Bf%28x_0%29&plus;2%5Csum_%7Bi%3D1%7D%5E%7Bn/2-1%7Df%28x_%7B2i%7D%29%20&plus;%204%5Csum_%7Bi%3D1%7D%5E%7Bn/2%7Df%28x_%7B2i-1%7D%29&plus;f%28x_n%29%5Cbigg%5D%2C)
     
     ![Graph](https://upload.wikimedia.org/wikipedia/en/6/67/Simpsonsrule2.gif)
     
     - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Simpson%27s_rule)
     
     - Parameter set: represent the data set for the integration.
     - Parameter dx: represent the sampling deferance of the data set.
     
     - Returns: the intrgral of the data set provided over the sampling deferance.
     
     */
    public static func simpsons(set: [Double], dx: Double) -> Double {
        
        // Insanaty check
        if set.count <= 1 {
            return 0
        }
        
        let n = set.count - 1
        let x0 = set[0]
        let xn = set[n]
        
        var sum4x: Double = 0.0
        var sum2x: Double = 0.0
        
        for i in 1..<n {
            let x = set[i]
            if (i % 2) == 0 {    // sum of evens. multiblay by 2
                sum2x += 2 * x
            } else {             // sum of odds. multibly by 4
                sum4x += 4 * x
            }
        }
        
        return dx/3 * (x0 + sum4x + sum2x + xn)
    }
}
