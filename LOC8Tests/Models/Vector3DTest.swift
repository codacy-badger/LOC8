//
//  Vector3DTest.swift
//  LOC8Tests
//
//  Created by Marwan Al Masri on 6/1/18.
//  Copyright © 2018 LOC8. All rights reserved.
//

import XCTest

@testable import LOC8

class Vector3DTest: LOC8Tests {

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
