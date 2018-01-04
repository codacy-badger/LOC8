//
//  Physics.swift
//  LOC8
//
//  Created by Marwan Al Masri on 3/29/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import Foundation

/**
 A structure that contain physics constants:
*/
public struct Physics {
    
    /// Earth gravity in m/s².
    public static let EarthGravity: Double = 9.80665 // m/s²
    
    /// Earth maximum magnetic field in microteslas.
    public static let EarthMaxMagneticField: Double = 65.0 // microteslas
    
    /// Earth minimum magnetic field in microteslas.
    public static let EarthMinMagneticField: Double = 25.0 // microteslas
}

/**
 # Acceleration
 
 Acceleration is defined as the rate of change of velocity.
 
 ### Discussion:

 Acceleration is inherently a vector quantity, and an object will have non-zero acceleration
 if its speed and/or direction is changing. The average acceleration is given by:
 __v = ∂v / ∂t__
 
 ![Equation](https://latex.codecogs.com/png.latex?%5Cdpi%7B150%7D%20v%20%3D%20%5Cfrac%7B%5Cpartial%20v%7D%7B%5Cpartial%20t%7D%20%3D%20%5Cfrac%7Bv_%7B2%7D%20-%20v_%7B1%7D%7D%7Bt_%7B2%7D%20-%20t_%7B1%7D%7D)
 
 ### where:
 * __v__ is velocity (m/s)
 * __t__ is time (s)
 
 - Note: measurment unit is meater per second sequer (m/s²)
 */
public typealias Acceleration = Vector3D

/**
 # Velocity
 
 The average speed of an object is defined as the distance traveled divided by the time elapsed.
 
 ### Discussion:
 Velocity is a vector quantity, and average velocity can be defined as the displacement
 divided by the time.For the special case of straight line motion in the x direction,
 the average velocity is given by:
 __v = ∂x / ∂t__
 
 ![Equation](https://latex.codecogs.com/png.latex?%5Cdpi%7B150%7D%20v%20%3D%20%5Cfrac%7B%5Cpartial%20x%7D%7B%5Cpartial%20t%7D%20%3D%20%5Cfrac%7Bx_%7B2%7D%20-%20x_%7B1%7D%7D%7Bt_%7B2%7D%20-%20t_%7B1%7D%7D)
 
 ### where:
 * __x__ is distance (m)
 * __t__ is time (s)
 
 - Note: measurment unit is meater per second (m/s)
 
 */
public typealias Velocity = Vector3D

/**
 # Distance
 
 ### Discussion:
 Distance is a scalar quantity that refers to "how much ground an object has covered" during its motion.
 
 - Note: measurment unit is meater (m)
 */
public typealias Distance = Vector3D 
