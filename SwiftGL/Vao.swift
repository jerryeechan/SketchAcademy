//
//  Vao.swift
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

open class Vao {
    var id: GLuint
    
    public init() {
        id = 0
        glGenVertexArrays(1, &id)
    }
    
    deinit {
        glDeleteVertexArrays(1, &id)
    }
    
    open func bind() {
        glBindVertexArray(id);
    }
}

public protocol GLType {
    static var glType: GLenum {get}
    static var glNormalized: GLboolean {get}
    static var glSize: GLint {get}
}

extension Float: GLType {
    public static var glType: GLenum {get {return GL_FLOAT}}
    public static var glNormalized: GLboolean {get {return GL_FALSE}}
    public static var glSize: GLint {get {return 1}}
}

extension Vec2: GLType {
    public static var glType: GLenum {get {return GL_FLOAT}}
    public static var glNormalized: GLboolean {get {return GL_FALSE}}
    public static var glSize: GLint {get {return 2}}
}

extension Vec3: GLType {
    public static var glType: GLenum {get {return GL_FLOAT}}
    public static var glNormalized: GLboolean {get {return GL_FALSE}}
    public static var glSize: GLint {get {return 3}}
}

extension Vec4: GLType {
    public static var glType: GLenum {get {return GL_FLOAT}}
    public static var glNormalized: GLboolean {get {return GL_FALSE}}
    public static var glSize: GLint {get {return 4}}
}

public extension Vao {
    public func bind <T: GLType> (attribute: GLuint, type: T.Type, vbo: Vbo, offset: GLsizeiptr) {
        glBindVertexArray(id)
        glEnableVertexAttribArray(attribute)
        glBindBuffer(GL_ARRAY_BUFFER, vbo.id)
        glVertexAttribPointer(attribute, type.glSize, type.glType, type.glNormalized, GLsizei(vbo.stride), UnsafeRawPointer(bitPattern: offset))
    }
    public func bind(attribute: GLuint, glType:GLenum,glNormalized: GLboolean,glSize: GLint , vbo: Vbo, offset: GLsizeiptr)
    {
        glBindVertexArray(id)
        glEnableVertexAttribArray(attribute)
        glBindBuffer(GL_ARRAY_BUFFER, vbo.id)
        glVertexAttribPointer(attribute, glSize, glType, glNormalized, GLsizei(vbo.stride), UnsafeRawPointer(bitPattern: offset))
    }
}

public extension Vao {
    public func bindElements(_ vbo: Vbo) {
        glBindVertexArray(id)
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vbo.id)
    }
}

public extension Vao {
    public func bindInstanced <T: GLType> (attribute: GLuint, type: T.Type, vbo: Vbo, offset: GLsizeiptr, divisor: GLuint = 1) {
        bind(attribute: attribute, type: type, vbo: vbo, offset: offset)
        glVertexAttribDivisor(attribute, divisor)
    }
}
