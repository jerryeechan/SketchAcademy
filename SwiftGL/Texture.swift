//
//  Texture.swift
//  SwiftGL
//
//  Created by Scott Bennett on 2014-06-15.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(OSX)
import OpenGL
#else
import OpenGLES
import ImageIO
import UIKit
#endif

public class Texture {
    public var id: GLuint
    public var width: GLsizei
    public var height: GLsizei
    
    public init() {
        id = 0
        width = 0
        height = 0
        glGenTextures(1, &id)
        
    }
    
    public convenience init(filename: String) {
        self.init()
        print("load texture")
        if(load(filename: filename)){
        print("init texture success \(filename)")
        }
        else{
            print("init texture fail")
        }
        
    }
    public convenience init(image:UIImage)
    {
        self.init()
        load(image: image, antialias: true, flipVertical: true)
    }
    public convenience init(w:GLsizei,h:GLsizei)
    {
        self.init()
        
        self.width = w
        self.height = h
        
        setTextureParameter()
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GLenum(GL_RGBA), GL_UNSIGNED_BYTE,nil);
    }
    
    deinit {
        print("deinit texture \(id)")
        glDeleteTextures(1, &id)
    }
    
    public func load(filename filename: String) -> Bool {
        return load(filename: filename, antialias: false, flipVertical: true)
    }
    
    public func load(filename filename: String, antialias: Bool) -> Bool {
        return load(filename: filename, antialias: antialias, flipVertical: true)
    }
    
    public func load(filename filename: String, flipVertical: Bool) -> Bool {
        return load(filename: filename, antialias: false, flipVertical: flipVertical)
    }
    
    /// @return true on success
    public func load(image image:UIImage, antialias: Bool, flipVertical: Bool)->Bool
    {
        

        let cgImage = image.CGImage
        var	brushContext:CGContextRef
        // Get the width and height of the image
        
        var brushData:UnsafeMutablePointer<Void>
        // Make sure the image exists
        if(cgImage != nil) {
            width = GLsizei(CGImageGetWidth(cgImage))
            height = GLsizei(CGImageGetHeight(cgImage))
            // Allocate  memory needed for the bitmap context
            brushData = calloc(Int(width * height * 4),sizeof(GLubyte))
            // Use  the bitmatp creation function provided by the Core Graphics framework.
            
            brushContext = CGBitmapContextCreate(brushData, Int(width), Int(height), 8, Int(width * 4),CGColorSpaceCreateDeviceRGB() ,CGImageAlphaInfo.PremultipliedLast.rawValue)!
            
            // After you create the context, you can draw the  image to the context.
            if flipVertical {
                CGContextTranslateCTM(brushContext, 0, CGFloat(Int(height)))
                CGContextScaleCTM(brushContext, 1, -1)
            }
            
            CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, CGFloat(width), CGFloat(height)), cgImage);
            // You don't need the context at this point, so you need to release it to avoid memory leaks.
            
            // Bind the texture name.
            setTextureParameter()
            
            //glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
            // Specify a 2D texture image, providing the a pointer to the image data in memory
            
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GLenum(GL_RGBA), GL_UNSIGNED_BYTE, brushData);
            
            // Release  the image data; it's no longer needed
            free(brushData);
            return true
        }
        return false
    }
    public func bind()
    {
        glBindTexture(GL_TEXTURE_2D, id);
    }
    public func empty()
    {
        glBindTexture(GL_TEXTURE_2D, id);
        let pixel = calloc(Int(width * height * 4),sizeof(GLubyte))
        glTexSubImage2D(SwiftGL.GL_TEXTURE_2D, 0, 0, 0, width, height, GLenum(GL_RGBA), SwiftGL.GL_UNSIGNED_BYTE, pixel)
        
        free(pixel)
        
    }
    private func setTextureParameter()
    {
        glBindTexture(GL_TEXTURE_2D, id);
        // Set the texture parameters to use a minifying filter and a linear filer (weighted average)
        
        glTexParameteri(SwiftGL.GL_TEXTURE_2D, GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
        glTexParameteri(SwiftGL.GL_TEXTURE_2D, GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR);
        
        glTexParameteri(SwiftGL.GL_TEXTURE_2D, GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(SwiftGL.GL_TEXTURE_2D, GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
    }
    public func load(filename filename: String, antialias: Bool, flipVertical: Bool) -> Bool {
        
        if(load(image:UIImage(named: filename)!,antialias: antialias,flipVertical:flipVertical))
        {
            return true
        }
        
        /*
        /////
        let imageData = Texture.Load(filename: filename, width: &width, height: &height, flipVertical: flipVertical)
        
        glBindTexture(GL_TEXTURE_2D, id)
        
        if antialias {
            glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR_MIPMAP_LINEAR)
            glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        } else {
            glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
            glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST)
        }
        
        glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
        glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
        
        #if os(OSX)
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GLenum(GL_BGRA), GLenum(GL_UNSIGNED_INT_8_8_8_8_REV), UnsafePointer(imageData))
        #else
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GLenum(GL_RGBA), GL_UNSIGNED_BYTE, UnsafePointer(imageData))
        #endif
        
        
        
        if antialias {
            glGenerateMipmap(GL_TEXTURE_2D)
        }
        
        free(imageData)
        return false
        
*/
        return false
    }
    
    private class func Load(filename filename: String, inout width: GLsizei, inout height: GLsizei, flipVertical: Bool) -> UnsafeMutablePointer<()> {
        let url = CFBundleCopyResourceURL(CFBundleGetMainBundle(), filename as NSString, "", nil)
        
        let imageSource = CGImageSourceCreateWithURL(url, nil)
        let image = CGImageSourceCreateImageAtIndex(imageSource!, 0, nil)
        
        width  = GLsizei(CGImageGetWidth(image))
        height = GLsizei(CGImageGetHeight(image))
        
        let zero: CGFloat = 0
        let rect = CGRectMake(zero, zero, CGFloat(Int(width)), CGFloat(Int(height)))
        let colourSpace = CGColorSpaceCreateDeviceRGB()
        
        let imageData: UnsafeMutablePointer<()> = malloc(Int(width * height * 4))
        
        
        let ctx = CGBitmapContextCreate(imageData, Int(width), Int(height), 8, Int(width * 4), colourSpace,CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        
        if flipVertical {
            CGContextTranslateCTM(ctx, zero, CGFloat(Int(height)))
            CGContextScaleCTM(ctx, 1, -1)
        }
        CGContextSetBlendMode(ctx, CGBlendMode.Copy)
        CGContextDrawImage(ctx, rect, image)
        // The caller is required to free the imageData buffer
        return imageData
    }
}
