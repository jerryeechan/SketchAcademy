//
//  PaintFileFormat.swift
//  SwiftGL
//
//  Created by jerry on 2015/6/3.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
class PaintFileHeader {
    var author:String!
    var filename:String!
    var created_time:CFAbsoluteTime = 0
    var json:JSON!
    init()
    {
        setHeader("test", author: "jerry")
    }
    func setHeader(filename:String,author:String)
    {
        
        json = JSON(["filename":filename,"author":author,"created_time":CFAbsoluteTimeGetCurrent()])
        
    }
    func getHeaderJSON()->JSON
    {
        return json
    }
    
}