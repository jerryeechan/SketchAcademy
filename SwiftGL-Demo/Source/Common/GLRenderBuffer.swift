//
//  GLRenderBuffer.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/26.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit
import OpenGLES.ES3
import GLKit
import SwiftGL

class GLRenderBuffer {
    var viewRenderbuffer:GLuint = 0
    var glcontext:EAGLContext!
    var eaglLayer:CAEAGLLayer!
    init(view:UIView)
    {
        self.glcontext = EAGLContext(API: EAGLRenderingAPI.OpenGLES3)
        if self.glcontext == nil {
            print("Failed to create ES context", terminator: "")
        }
        
        EAGLContext.setCurrentContext(self.glcontext)
        eaglLayer = view.layer as! CAEAGLLayer
        
        eaglLayer.opaque = false
        
        eaglLayer.drawableProperties = [kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8,kEAGLDrawablePropertyRetainedBacking:true]
        
        glGenRenderbuffers(1, &viewRenderbuffer)
        glBindRenderbuffer(GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        glcontext.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable: eaglLayer)

    }
}