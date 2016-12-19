//
//  Vec2.swift
//  SwiftGL
//
//  Created by Scott Bennett on 2014-06-08.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Darwin
import CoreGraphics
public struct Vec2 {
    public var x, y: Float
    
    public init() {
        self.x = 0
        self.y = 0
    }
    
    // Explicit initializers
    
    public init(s: Float) {
        self.x = s
        self.y = s
    }
    
    public init(x: Float) {
        self.x = x
        self.y = 0
    }
    public init(x: Int, y:Int) {
        self.x = Float(x)
        self.y = Float(y)
    }
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    // Implicit initializers
    
    public init(_ x: Float) {
        self.x = x
        self.y = 0
    }
    public init(point:CGPoint)
    {
        self.x = Float(point.x)
        self.y = Float(point.y)
    }
    public init(cgVector:CGVector)
    {
        self.x = Float(cgVector.dx)
        self.y = Float(cgVector.dy)
    }
    public init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
    
    
    public var length2: Float {
        get {
            return x * x + y * y
        }
    }
    
    public var length: Float {
        get {
            return sqrt(self.length2)
        }
        set {
            self = length * normalize(self)
        }
    }
    public var unit:Vec2
    {
        get{
            return normalize(self)
        }
    }
    
    // Swizzle (Vec2) Properties
    public var xx: Vec2 {get {return Vec2(x: x, y: x)}}
    public var yx: Vec2 {get {return Vec2(x: y, y: x)} set(v) {self.y = v.x; self.x = v.y}}
    public var xy: Vec2 {get {return Vec2(x: x, y: y)} set(v) {self.x = v.x; self.y = v.y}}
    public var yy: Vec2 {get {return Vec2(x: y, y: y)}}
    
    // Swizzle (Vec3) Properties
    public var xxx: Vec3 {get {return Vec3(x: x, y: x, z: x)}}
    public var yxx: Vec3 {get {return Vec3(x: y, y: x, z: x)}}
    public var xyx: Vec3 {get {return Vec3(x: x, y: y, z: x)}}
    public var yyx: Vec3 {get {return Vec3(x: y, y: y, z: x)}}
    public var xxy: Vec3 {get {return Vec3(x: x, y: x, z: y)}}
    public var yxy: Vec3 {get {return Vec3(x: y, y: x, z: y)}}
    public var xyy: Vec3 {get {return Vec3(x: x, y: y, z: y)}}
    public var yyy: Vec3 {get {return Vec3(x: y, y: y, z: y)}}
    
    // Swizzle (Vec4) Properties
    public var xxxx: Vec4 {get {return Vec4(x: x, y: x, z: x, w: x)}}
    public var yxxx: Vec4 {get {return Vec4(x: y, y: x, z: x, w: x)}}
    public var xyxx: Vec4 {get {return Vec4(x: x, y: y, z: x, w: x)}}
    public var yyxx: Vec4 {get {return Vec4(x: y, y: y, z: x, w: x)}}
    public var xxyx: Vec4 {get {return Vec4(x: x, y: x, z: y, w: x)}}
    public var yxyx: Vec4 {get {return Vec4(x: y, y: x, z: y, w: x)}}
    public var xyyx: Vec4 {get {return Vec4(x: x, y: y, z: y, w: x)}}
    public var yyyx: Vec4 {get {return Vec4(x: y, y: y, z: y, w: x)}}
    public var xxxy: Vec4 {get {return Vec4(x: x, y: x, z: x, w: y)}}
    public var yxxy: Vec4 {get {return Vec4(x: y, y: x, z: x, w: y)}}
    public var xyxy: Vec4 {get {return Vec4(x: x, y: y, z: x, w: y)}}
    public var yyxy: Vec4 {get {return Vec4(x: y, y: y, z: x, w: y)}}
    public var xxyy: Vec4 {get {return Vec4(x: x, y: x, z: y, w: y)}}
    public var yxyy: Vec4 {get {return Vec4(x: y, y: x, z: y, w: y)}}
    public var xyyy: Vec4 {get {return Vec4(x: x, y: y, z: y, w: y)}}
    public var yyyy: Vec4 {get {return Vec4(x: y, y: y, z: y, w: y)}}
}

// Make it easier to interpret Vec2 as a string
extension Vec2: CustomStringConvertible, CustomDebugStringConvertible {
    public var description:      String {get {return "(\(x), \(y))"}}
    public var debugDescription: String {get {return "Vec2(x: \(x), y: \(y))"}}
}
extension Vec2{
    public var tojson:String{get{return "{\"x\":\(x),\"y\":\(y)}"}}
}

// Vec2 Prefix Operators
public prefix func - (v: Vec2) -> Vec2 {return Vec2(x: -v.x, y: -v.y)}

// Vec2 Infix Operators
public func + (a: Vec2, b: Vec2) -> Vec2 {return Vec2(x: a.x + b.x, y: a.y + b.y)}
public func - (a: Vec2, b: Vec2) -> Vec2 {return Vec2(x: a.x - b.x, y: a.y - b.y)}
public func * (a: Vec2, b: Vec2) -> Vec2 {return Vec2(x: a.x * b.x, y: a.y * b.y)}
public func / (a: Vec2, b: Vec2) -> Vec2 {return Vec2(x: a.x / b.x, y: a.y / b.y)}

// Vec2 Scalar Operators
public func * (s: Float, v: Vec2) -> Vec2 {return Vec2(x: s * v.x, y: s * v.y)}
public func * (v: Vec2, s: Float) -> Vec2 {return Vec2(x: v.x * s, y: v.y * s)}
public func / (v: Vec2, s: Float) -> Vec2 {return Vec2(x: v.x / s, y: v.y / s)}

// Vec2 Assignment Operators
public func += (a: inout Vec2, b: Vec2) {a = a + b}
public func -= (a: inout Vec2, b: Vec2) {a = a - b}
public func *= (a: inout Vec2, b: Vec2) {a = a * b}
public func /= (a: inout Vec2, b: Vec2) {a = a / b}

public func *= (a: inout Vec2, b: Float) {a = a * b}
public func /= (a: inout Vec2, b: Float) {a = a / b}

public func < (a:Vec2,b:Vec2)->Bool
{
    return (a.x < b.x && a.y < b.y)
}
public func <= (a:Vec2,b:Vec2)->Bool
{
    return (a.x <= b.x && a.y <= b.y)
}
public func >= (a:Vec2,b:Vec2)->Bool
{
    return (a.x >= b.x && a.y >= b.y)
}
public func > (a:Vec2,b:Vec2)->Bool
{
    return (a.x > b.x && a.y > b.y)
}
// Functions which operate on Vec2
public func length(_ v: Vec2) -> Float {return v.length}
public func length2(_ v: Vec2) -> Float {return v.length2}
public func normalize(_ v: Vec2) -> Vec2 {return v / v.length}
public func dot(_ a: Vec2, b: Vec2) -> Float {return a.x * b.x + a.y * b.y}

public func clamp(_ value: Vec2, min: Float, max: Float) -> Vec2 {return Vec2(clamp(value.x, min: min, max: max), clamp(value.y, min: min, max: max))}
public func mix(_ a: Vec2, b: Vec2, t: Float) -> Vec2 {return a + (b - a) * t}
public func smoothstep(_ a: Vec2, b: Vec2, t: Float) -> Vec2 {return mix(a, b: b, t: t * t * (3 - 2 * t))}

public func clamp(_ value: Vec2, min: Vec2, max: Vec2) -> Vec2 {return Vec2(clamp(value.x, min: min.x, max: max.x), clamp(value.y, min: min.y, max: max.y))}
public func mix(_ a: Vec2, b: Vec2, t: Vec2) -> Vec2 {return a + (b - a) * t}
public func smoothstep(_ a: Vec2, b: Vec2, t: Vec2) -> Vec2 {return mix(a, b: b, t: t * t * (Vec2(s: 3) - 2 * t))}
