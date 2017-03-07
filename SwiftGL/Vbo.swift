//
//  Vbo.swift
//  SwiftGL
//
//  Created by Scott Bennett on 2014-06-09.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Foundation

#if os(OSX)
import OpenGL
#else
import OpenGLES
#endif

open class Vbo {
    var id: GLuint
    open var count: GLsizeiptr
    var stride: GLsizeiptr
    
    public init() {
        id     = 0
        count  = 0
        stride = 0
        glGenBuffers(1, &id)
    }
    
    deinit {
        glDeleteBuffers(1, &id)
    }
    
    open func reset() {
        count  = 0
        stride = 0
        glBindBuffer(GL_ARRAY_BUFFER, id)
        glBufferData(GL_ARRAY_BUFFER, 0, nil, GL_DYNAMIC_DRAW)
    }
}
 
// NOTE: You cannot bind both vertex data and element data to the same VBO,
//       Two separate VBOs must be used (then bound to the same VAO)

public extension Vbo {
    public func bind <T> (_ data: UnsafePointer<T>, count: GLsizeiptr) {
        self.count  = count
        self.stride = MemoryLayout<T>.size
        glBindBuffer(GL_ARRAY_BUFFER, id)
        glBufferData(GL_ARRAY_BUFFER, stride * count, data, GL_STATIC_DRAW)
    }
    public func bindSubData <T> (_ data: UnsafePointer<T>, start: GLsizeiptr, count: GLsizeiptr) {
        self.count  = count
        self.stride = MemoryLayout<T>.size
        glBindBuffer(GL_ARRAY_BUFFER, id)
        glBufferSubData(GL_ARRAY_BUFFER, stride * start, stride * count, data)
    }
}

public extension Vbo {
    public func bindElements <T> (_ data: UnsafePointer<T>, count: GLsizeiptr) {
        self.count  = count
        self.stride = MemoryLayout<T>.size
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, id)
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, stride * count, data, GL_STATIC_DRAW)
    }
    
    public func bindSubElements <T> (_ data: UnsafePointer<T>, count: GLsizeiptr) {
        self.count  = count
        self.stride = MemoryLayout<T>.size
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, id)
        glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, stride * count, stride * count, data)
    }
}
