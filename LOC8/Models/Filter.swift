//
//  Filter.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/9/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation

/**
 Enumerates the Filter types.
 */
public enum FilterType: String {
    
    /**
     A low-pass filter is a filter that passes signals with a frequency lower than a certain cutoff frequency and attenuates signals with frequencies higher than the cutoff frequency.
     
    The amount of attenuation for each frequency depends on the filter design.
     
     - SeeAlso: For more information and details, see [Wikipedia](http://en.wikipedia.org/wiki/Low-pass_filter).
     */
    case lowpass = "Lowpass"
    
    /**
     A high-pass filter is a filter that passes signals with a frequency higher than a certain cutoff frequency and attenuates signals with frequencies lower than the cutoff frequency.
     
     The amount of attenuation for each frequency depends on the filter design.
     
     - SeeAlso: For more information and details, see [Wikipedia](http://en.wikipedia.org/wiki/High-pass_filter).
     */
    case highpass = "Highpass"
    
    /// No filter type just pass the data as it is.
    case non = "Non"
}

/**
 An implentetion for a linear digital filter, that can be:
 
 - Lowpass filter
 - Highpass filter
 
 Also you can spacify if the filter is adptive or not.
 
 ### Discussion:
 A filter is a process that removes from a signal some unwanted component or feature.
 
 */
open class Filter: NSObject {
    
    // MARK: Properties
    
    ///`Double` value represent the filter minimum step.
    fileprivate let minStep = 0.02
    
    ///`Double` value represent the filter noise attenuation.
    fileprivate let noiseAttenuation = 3.0
    
    /**
     A Boolean value that determines whether the filter is adaptive or not.
     
    Specify true for adaptive filter. otherwise, specify false.
     
     - Attention: The default value is __true__.
     */
    open var adaptive: Bool = true
    
    /// A `Double` value that represent the filter time constant.
    public let filterConstant: Double!
    
    /// A `FilterType` value that represent the filter type.
    public let type: FilterType!
    
    /// A `Double` value that represent the current value.
    private(set) var value: Double = 0
    
    /// A `Double` value that represent the last value.
    fileprivate var lastValue: Double = 0
    
    // MARK: Initialaization
    
    /**
     `Filter` Default initializer.
     */
    public override init() {
        self.type = .non
        filterConstant = 0
        super.init()
    }
    
    /**
      Initialize Filter object
     
      - Parameter type: A `FilterType` value represent the filter type.
      - Parameter rate: A `Double` value represent the date rate of the date.
      - Parameter freq: A `Double` value represent the cutoff frequency.
     */
    public init(type: FilterType, rate: Double, cutoffFrequency freq: Double) {
        
        self.type = type
        
        let dt: Double = 1.0 / rate // time interval
        let RC: Double = 1.0 / freq // time constant
        
        switch type {
        case .lowpass: filterConstant = dt / (dt + RC)
        case .highpass: filterConstant = RC / (dt + RC)
        case .non: filterConstant = 0
        }
        
        super.init()
    }
    
    // MARK: Methods
    
    /**
     Add new value to the filter.
     - Parameter value: A `Double` value represent the new value
     */
    open func addValue(_ value: Double) {
        
        switch self.type! {
        case FilterType.lowpass:self.addValueToLowpass(value)
        case FilterType.highpass:self.addValueToHighpass(value)
        case .non: self.addValueWithoutFilter(value)
        }
    }
    
    /**
     Add new value without filtering any data.
     - Parameter value: A `Double` value represent the new value
     */
    fileprivate func addValueWithoutFilter(_ value: Double) {
        self.value = value
    }
    
    /**
     Add new value to a lowpass filter.
     - Parameter value: A `Double` value represent the new value
     
     - SeeAlso: For more information and details, see [Wikipedia](http://en.wikipedia.org/wiki/Low-pass_filter).
     */
    fileprivate func addValueToLowpass(_ value: Double) {

        var alpha: Double = filterConstant!

        if adaptive {
            let d: Double = Geometry.clamp(value: abs(self.value - value) / minStep - 1.0, min: 0.0, max: 1.0)
            
            alpha = (1.0 - d) * filterConstant! / noiseAttenuation + d * filterConstant!
        }

        self.value = value * alpha + self.value * (1.0 - alpha)

        lastValue = value
    }
    
    /**
     Add new value to a highpass filter.
     - Parameter value: A `Double` value represent the new value
     
     - SeeAlso: For more information and details, see [Wikipedia](http://en.wikipedia.org/wiki/High-pass_filter).
     */
    fileprivate func addValueToHighpass(_ value: Double) {

        var alpha: Double = filterConstant!

        if adaptive {
            let d: Double = Geometry.clamp(value: abs(self.value - value) / minStep - 1.0, min: 0.0, max: 1.0)
            
            alpha = d * filterConstant! / noiseAttenuation + (1.0 - d) * filterConstant!
        }
        
        self.value = alpha * (self.value + value - lastValue)

        lastValue = value
    }
    
    open override var description: String {
        return (adaptive ? "Adaptive " : "") + (type != .non ? "\(String(describing: type)) " : "") + "Filter"
    }
}

/**
 An implentetion for a linear digital filter, that is responsable for processing acceleration data, and remove thae noise. this filter can be:
 
 - Lowpass filter
 - Highpass filter
 
 Also you can spacify if the filter is adptive or not.
 
 ### Discussion:
 A filter is a process that removes from a signal some unwanted component or feature.
 This object is responseabel of processing an acceleration data to remove noise.
 
 */
open class AccelerationFilter: NSObject {
    
    // MARK: Properties
    
    ///`Double` value represent the filter minimum step.
    fileprivate let minStep = 0.02
    
    ///`Double` value represent the filter noise attenuation.
    fileprivate let noiseAttenuation = 3.0
    
    /**
     A Boolean value that determines whether the filter is adaptive or not.
     
     Specify true for adaptive filter. otherwise, specify false.
     
     - Attention: The default value is __true__.
     */
    open var adaptive: Bool = true
    
    /// A `Double` value that represent the filter time constant.
    public let filterConstant: Double!
    
    /// A `FilterType` value that represent the filter type.
    public let type: FilterType!
    
    /// A `Acceleration` value that represent the current acceleration.
    private(set) var value: Acceleration = Acceleration()
    
    /// A `Acceleration` value that represent the last acceleration.
    fileprivate var lastValue: Acceleration = Acceleration()
    
    // MARK: Initialaization
    
    /**
     `Filter` Default initializer.
     */
    public override init() {
        self.type = .non
        filterConstant = 0
        super.init()
    }
    
    /**
      Initialize Filter object
     
      - Parameter type: A `FilterType` value represent the filter type.
      - Parameter rate: A `Double` value represent the date rate of the date.
      - Parameter freq: A `Double` value represent the cutoff frequency.
     */
    public init(type: FilterType, rate: Double, cutoffFrequency freq: Double) {
        
        self.type = type
        
        let dt: Double = 1.0 / rate // time interval
        let RC: Double = 1.0 / freq // time constant
        
        switch type {
        case .lowpass: filterConstant = dt / (dt + RC)
        case .highpass: filterConstant = RC / (dt + RC)
        case .non: filterConstant = 0
        }
        
        super.init()
    }
    
    // MARK: Methods
    
    /**
     Add new value to the filter.
     - Parameter value: A `Double` value represent the new value
     */
    open func addValue(_ value: Acceleration) {
        
        switch self.type! {
        case FilterType.lowpass:self.addValueToLowpass(value)
        case FilterType.highpass:self.addValueToHighpass(value)
        case .non: self.addValueWithoutFilter(value)
        }
    }
    
    /**
     Add new value without filtering any data.
     - Parameter value: A `Double` value represent the new value
     */
    fileprivate func addValueWithoutFilter(_ value: Acceleration) {
        self.value = value
    }
    
    /**
     Add new value to a lowpass filter.
     - Parameter value: A `Double` value represent the new value
     
     - SeeAlso: For more information and details, see [Wikipedia](http://en.wikipedia.org/wiki/Low-pass_filter).
     */
    fileprivate func addValueToLowpass(_ value: Acceleration) {
        // See http://en.wikipedia.org/wiki/Low-pass_filter for details low pass filtering
        
        var x = self.value.x
        var y = self.value.y
        var z = self.value.z
        
        var alpha: Double = filterConstant!
        
        if adaptive {
            let d: Double = Geometry.clamp(value: abs(~self.value - ~value / minStep) - 1.0, min: 0.0, max: 1.0)
            
            alpha = (1.0 - d) * filterConstant! / noiseAttenuation + d * filterConstant!
        }
        
        x = value.x * alpha + x * (1.0 - alpha)
        y = value.y * alpha + y * (1.0 - alpha)
        z = value.z * alpha + z * (1.0 - alpha)
        
        self.value = Acceleration(x: x, y: y, z: z)
        
        lastValue = value
    }
    
    /**
     Add new value to a highpass filter.
     - Parameter value: A `Double` value represent the new value
     
     - SeeAlso: For more information and details, see [Wikipedia](http://en.wikipedia.org/wiki/High-pass_filter).
     */
    fileprivate func addValueToHighpass(_ value: Acceleration) {
        // See http://en.wikipedia.org/wiki/High-pass_filter for details on high pass filtering
        
        var x = self.value.x
        var y = self.value.y
        var z = self.value.z
        
        var alpha: Double = filterConstant!
        
        if adaptive {
            let d: Double = Geometry.clamp(value: fabs(~self.value - ~value) / minStep - 1.0, min: 0.0, max: 1.0)
            
            alpha = d * filterConstant! / noiseAttenuation + (1.0 - d) * filterConstant!
        }
        x = alpha * (x + value.x - lastValue.x)
        y = alpha * (y + value.y - lastValue.y)
        z = alpha * (z + value.z - lastValue.z)
        
        self.value = Vector3D(x: x, y: y, z: z)
        
        lastValue = value
    }
    
    open override var description: String {
        return "Acceleration" + (adaptive ? "Adaptive " : "") + (type != .non ? "\(String(describing: type)) " : "") + "Filter"
    }
}
