//
//  Filter.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/9/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

//MARK:- Filter Type

/**
 * Heading FilterType
 *
 * - Lowpass
 * - Highpass
 * - Non
 */
public enum FilterType: String {
    case Lowpass = "Lowpass"
    case Highpass = "Highpass"
    case Non = "Non"
}

//MARK:- Filter

/**
 * Filter
 *
 *  Discussion:
 *   A filter is a process that removes from a signal some unwanted component or feature.
 *
 */
public class Filter: NSObject {
    
    //MARK: Properties
    private let minStep = 0.02
    
    private let noiseAttenuation = 3.0
    
    public var adaptive: Bool = true
    
    public let filterConstant: Double!
    
    public let type: FilterType!
    
    private(set) var value: Double = 0
    
    private var lastValue: Double = 0
    
    //MARK: Initialaization
    public override init() {
        self.type = .Non
        filterConstant = 0
        super.init()
    }
    
    public init(type: FilterType, rate: Double, cutoffFrequency freq: Double) {
        
        self.type = type
        
        let dt: Double = 1.0 / rate // time interval
        let RC: Double = 1.0 / freq // time constant
        
        switch type {
        case .Lowpass: filterConstant = dt / (dt + RC)
        case .Highpass: filterConstant = RC / (dt + RC)
        case .Non: filterConstant = 0
        }
        
        super.init()
    }
    
    //MARK: Methods
    public func addValue(value: Double) {
        
        switch self.type! {
        case FilterType.Lowpass:self.addValueToLowpass(value)
        case FilterType.Highpass:self.addValueToHighpass(value)
        case .Non: self.addValueWithoutFilter(value)
        }
    }
    
    private func addValueWithoutFilter(value: Double) {
        self.value = value
    }
    
    private func addValueToLowpass(value: Double) {

        var alpha: Double = filterConstant!

        if adaptive {
            let d: Double = clamp(abs(self.value - value) / minStep - 1.0, min: 0.0, max: 1.0)
            alpha = (1.0 - d) * filterConstant! / noiseAttenuation + d * filterConstant!
        }

        self.value = value * alpha + self.value * (1.0 - alpha)

        lastValue = value
    }

    private func addValueToHighpass(value: Double){

        var alpha: Double = filterConstant!

        if adaptive {
            let d: Double = clamp(abs(self.value - value) / minStep - 1.0, min: 0.0, max: 1.0)
            alpha = d * filterConstant! / noiseAttenuation + (1.0 - d) * filterConstant!
        }
        
        self.value = alpha * (self.value + value - lastValue)

        lastValue = value
    }
}

//MARK:- Acceleration Filter

/**
 * Acceleration Filter
 *
 *  Discussion:
 *   A filter is a process that removes from a signal some unwanted component or feature.
 *   This object is responseabel of processing an acceleration data to remove noise.
 *
 */
public class AccelerationFilter: NSObject {
    
    //MARK: Properties
    private let minStep = 0.02
    
    private let noiseAttenuation = 3.0
    
    public var adaptive: Bool = true
    
    public let filterConstant: Double!
    
    public let type: FilterType!
    
    private(set) var value: Acceleration = Acceleration()
    
    private var lastValue: Acceleration = Acceleration()
    
    //MARK: Initialaization
    public override init() {
        self.type = .Non
        filterConstant = 0
        super.init()
    }
    
    public init(type: FilterType, rate: Double, cutoffFrequency freq: Double) {
        
        self.type = type
        
        let dt: Double = 1.0 / rate // time interval
        let RC: Double = 1.0 / freq // time constant
        
        switch type {
        case .Lowpass: filterConstant = dt / (dt + RC)
        case .Highpass: filterConstant = RC / (dt + RC)
        case .Non: filterConstant = 0
        }
        
        super.init()
    }
    
    //MARK: Methods
    public func addValue(value: Acceleration) {
        
        switch self.type! {
        case FilterType.Lowpass:self.addValueToLowpass(value)
        case FilterType.Highpass:self.addValueToHighpass(value)
        case .Non: self.addValueWithoutFilter(value)
        }
    }
    
    private func addValueWithoutFilter(value: Acceleration) {
        self.value = value
    }
    
    private func addValueToLowpass(value: Acceleration) {
        // See http://en.wikipedia.org/wiki/Low-pass_filter for details low pass filtering
        
        var x = self.value.x
        var y = self.value.y
        var z = self.value.z
        
        var alpha: Double = filterConstant!
        
        if adaptive {
            let d: Double = clamp(abs(~self.value - ~value / minStep) - 1.0, min: 0.0, max: 1.0)
            alpha = (1.0 - d) * filterConstant! / noiseAttenuation + d * filterConstant!
        }
        
        x = value.x * alpha + x * (1.0 - alpha)
        y = value.y * alpha + y * (1.0 - alpha)
        z = value.z * alpha + z * (1.0 - alpha)
        
        self.value = Acceleration(x: x, y: y, z: z)
        
        lastValue = value
    }
    
    private func addValueToHighpass(value: Acceleration) {
        // See http://en.wikipedia.org/wiki/High-pass_filter for details on high pass filtering
        
        var x = self.value.x
        var y = self.value.y
        var z = self.value.z
        
        var alpha: Double = filterConstant!
        
        if adaptive {
            let d: Double = clamp(fabs(~self.value - ~value) / minStep - 1.0, min: 0.0, max: 1.0)
            alpha = d * filterConstant! / noiseAttenuation + (1.0 - d) * filterConstant!
        }
        x = alpha * (x + value.x - lastValue.x)
        y = alpha * (y + value.y - lastValue.y)
        z = alpha * (z + value.z - lastValue.z)
        
        self.value = Vector3D(x: x, y: y, z: z)
        
        lastValue = value
    }
    
    public override var description: String {
        return "Acceleration" + (adaptive ? "Adaptive " : "") + (type != .Non ? "\(type) " : "") + "Filter"
    }
}