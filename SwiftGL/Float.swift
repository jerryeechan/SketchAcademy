//
//  Float.swift
//  SwiftGL
//
//  Created by Scott Bennett on 2014-06-08.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Darwin

public let Pi = Float(M_PI)

public func radians(_ degrees: Float) -> Float {return degrees * Pi / 180}
public func degrees(_ radians: Float) -> Float {return radians * 180 / Pi}

public func sign(_ value: Float) -> Float {return (value > 0 ? 1 : (value < 0 ? -1 : 0))}

// Overload some mathematical functions to make them easier to call without having to worry about as many casts
//public func sqrt(value: Float)  -> Float {return sqrtf(value);}

public func sin(_ radians: Float) -> Float {return sinf(radians)}
public func cos(_ radians: Float) -> Float {return cosf(radians)}
public func tan(_ radians: Float) -> Float {return tanf(radians)}

public func sin(radians: Float) -> Float {return sinf(radians)}
public func cos(radians: Float) -> Float {return cosf(radians)}
public func tan(radians: Float) -> Float {return tanf(radians)}

public func sin(degrees: Float) -> Float {return sinf(radians(degrees))}
public func cos(degrees: Float) -> Float {return cosf(radians(degrees))}
public func tan(degrees: Float) -> Float {return tanf(radians(degrees))}

public func clamp(_ value: Float, min: Float, max: Float) -> Float {return value < min ? min : (value > max ? max : value)}
public func mix(_ a: Float, b: Float, t: Float) -> Float {return a + (b - a) * t}
public func smoothstep(_ a: Float, b: Float, t: Float) -> Float {return mix(a, b: b, t: clamp(t * t * (3 - 2 * t), min: 0, max: 1))}
