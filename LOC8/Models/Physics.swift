//
//  Physics.swift
//  LOC8
//
//  Created by Marwan Al Masri on 3/29/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import Foundation
#if os(iOS)
    import CoreMotion
#endif

/*
 Measurment Units
 
 This library follow SI (The International System of Units)
 
 Metre for length.
 Kilogram for mass.
 Second for time.
 Radian for angels.
 Tesla for magnetic field. (In SI base units:	kg⋅s⁻²⋅A⁻¹)
 
*/


/*
 The Kinematic Equations

                   1
 (1) d = vᵢ * t + ––– * a * t²
                   2

 (2) (vᵢ₊₁)² = (vᵢ)² + 2 * a * d


 (3) vᵢ₊₁ = vᵢ + a * t

          vᵢ + vᵢ₊₁
 (4) d = ––––––––––– * t
              2

  where:
      - a is acceleration (m/s²)
      - v is velocity (m/s)
      - d is distance (m)
      - t is time (s)

*/


public struct Physics {
    public static let EarthGravity: Double = 9.80665 //m/s²
    public static let EarthMaxMagneticField: Double = 65.0 //microteslas
    public static let EarthMinMagneticField: Double = 25.0 //microteslas
}


//MARK:- Acceleration
/**
 *  Acceleration
 *
 *  Discussion:
 *    Acceleration is defined as the rate of change of velocity.
 *
 *    Acceleration is inherently a vector quantity, and an object will have non-zero acceleration 
 *    if its speed and/or direction is changing. The average acceleration is given by:
 *
 *       ͢    ∆v     v₂ - v₁
 *      a = –––– = –––––––––
 *           ∆t     t₂ - t₁
 */
public typealias Acceleration = Vector3D

public extension Acceleration {
    
}

#if os(iOS)
    public extension Acceleration {
        
        public convenience init(acceleration: CMAcceleration){
            
            let x = acceleration.x * Physics.EarthGravity
            let y = acceleration.y * Physics.EarthGravity
            let z = acceleration.z * Physics.EarthGravity
            
            self.init(x: x, y: y, z: z)
        }
    }
#endif

//MARK:- Velocity
/**
 *  Velocity
 *
 *  Discussion:
 *    The average speed of an object is defined as the distance traveled divided by the time elapsed.
 *
 *    Velocity is a vector quantity, and average velocity can be defined as the displacement
 *    divided by the time.For the special case of straight line motion in the x direction, 
 *    the average velocity is given by:
 *
 *       ͢    ∆x     x₂ - x₁
 *      v = –––– = –––––––––
 *           ∆t     t₂ - t₁
 */
public typealias Velocity = Vector3D


//MARK:- Distance
/**
 *  Distance
 *
 *  Discussion:
 *    Distance is a scalar quantity that refers to "how much ground an object has covered" during its motion.
 */
public typealias Distance = Vector3D

