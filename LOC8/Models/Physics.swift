//
//  Physics.swift
//  LOC8
//
//  Created by Marwan Al Masri on 3/29/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import Foundation

//MARK: Physics


/**
 # Physics
 
 ### Discussion:
 A structure that contain physics constants:
 
 - Earth gravity
 - Earth maximum magnetic field
 - Earth minimum magnetic field
 
 # Library Fundamentals
 
 ## Measurment Units
 
 This library follow SI (The International System of Units)
 
 - Metre for length.
 - Kilogram for mass.
 - Second for time.
 - Radian for angels.
 - Tesla for magnetic field. _(In SI base units:	kg⋅s⁻²⋅A⁻¹)_
 
 ## Kinematic Equations
    The equations can be utilized for any motion that can be described as being either a constant velocity motion or a constant acceleration motion. 
    They can never be used over any time period during which the acceleration is changing. Each of the kinematic equations include four variables.
 
 
 ````
                   1
 (1) d = vᵢ * t + ––– * a * t²
                   2

 (2) (vᵢ₊₁)² = (vᵢ)² + 2 * a * d

 
 (3) vᵢ₊₁ = vᵢ + a * t

          vᵢ + vᵢ₊₁
 (4) d = ––––––––––– * t
              2
 ````

  ### where:
    * __a__ is acceleration (m/s²)
    * __v__ is velocity (m/s)
    * __d__ is distance (m)
    * __t__ is time (s)

*/
public struct Physics {
    
    ///Earth gravity in m/s².
    public static let EarthGravity: Double = 9.80665 //m/s²
    
    ///Earth maximum magnetic field in microteslas.
    public static let EarthMaxMagneticField: Double = 65.0 //microteslas
    
    ///Earth minimum magnetic field in microteslas.
    public static let EarthMinMagneticField: Double = 25.0 //microteslas
}


/**
 # Acceleration
 
 ### Discussion:
    Acceleration is defined as the rate of change of velocity.
 
    Acceleration is inherently a vector quantity, and an object will have non-zero acceleration
    if its speed and/or direction is changing. The average acceleration is given by:
 
  ````
    ͢     ∆v     v₂ - v₁
    a = –––– = –––––––––
         ∆t     t₂ - t₁
  ````
 
 ### where:
 * __v__ is velocity (m/s)
 * __t__ is time (s)
 
 - Note: measurment unit is meater per second sequer (m/s²)
 */
public typealias Acceleration = Vector3D

/**
 # Velocity
 
 ### Discussion:
    The average speed of an object is defined as the distance traveled divided by the time elapsed.
 
    Velocity is a vector quantity, and average velocity can be defined as the displacement
    divided by the time.For the special case of straight line motion in the x direction,
    the average velocity is given by:
 
 ````
    ͢     ∆x     x₂ - x₁
    v = –––– = –––––––––
         ∆t     t₂ - t₁
 ````
 
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

