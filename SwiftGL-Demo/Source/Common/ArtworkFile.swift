//
//  ArtworkFile.swift
//  SwiftGL
//
//  Created by jerry on 2015/10/28.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
class ArtworkFile:File{

    override init()
    {
        
    }
    
    //!!change to getScreenShot
    
/*
    paw format:
    
    Int: number of strokes
    {
    Int: stroke using Tool name string length
    VL: tool name String
    {
    Int: number of Points
    VL Vec2:  position
    VL Double: timeinterval
    VL Vec2:  velocity
    }
    }
    
    
    rev format:
    
    Int: number of revise
    {
    Int: title string length
    VL: title string
    
    Int: description string length
    VL: description string
    
    
    }
    
*/
    
    //encode and save and write
    
    // stroke count :Int
    // strokes []
        //toolName :string
        //brushTexture :string
        //valueInfo    :ToolValueInfo
        //pointData    :[PointData]
    func save(filename:String,artwork:PaintArtwork)
    {
        var strokes = artwork.strokes
        
        data = NSMutableData()

        encodeStruct(strokes.count)
        for var i=0;i<strokes.count; i++
        {
            let strInfo = strokes[i].stringInfo
            let pointData = strokes[i].pointData
            
            encodeString(strInfo.toolName)
            encodeString(strInfo.brushTexture)
            encodeStruct(strokes[i].valueInfo)
            //the point infomation byte arrays, vec2[], double[] ,vec2[]
            encodeStructArray(pointData)
        }
        let path = File.dirpath
        print(path)
        data.writeToFile(path+"/"+filename+".paw", atomically: true)
        
    }
    //---------------------------------------------------------------
    //  load
    //
    //---------------------------------------------------------------
    
    
    
    
    
    
    func load(filename:String)->PaintArtwork!
    {
        let path = createPath(filename)
        print(path)
        if checkFileExist(path)
        {
            parseData = readFile(filename)
            currentPtr = 0
            
            let artwork =  PaintArtwork()

            // stroke count :Int
            let strokeCount:Int = parseStruct()
            
            // strokes []
            for var i=0; i < strokeCount; i++ {
                
                //parse string info
                var tSI = parseToolStringInfo(parseData)
                var tVI:ToolValueInfo
                if(tSI==nil)
                {
                    
                    print("nil tSI")
                    tSI = lastTSI
                    tVI = lastTVI
                }
                else
                {
                    //valueInfo    :ToolValueInfo
                    tVI = parseToolValueInfo(parseData)
                }
                
                let stroke = PaintStroke(s: tSI, v: tVI)
                
                //pointData    :[PointData]
                let pointData:[PointData] = parseStructArray()
                stroke.pointData = pointData
                stroke.genPointsFromPointData()
                
                
                artwork.addPaintStroke(stroke)
            }
            
            return artwork
        }
        else
        {
            return nil
        }
        //data.getBytes(&brushString, range: )
    }
    
    func parseStrokeCount(data:NSData)->Int
    {
        var strokeCount = 0
        parseData.getBytes(&strokeCount, range: NSMakeRange(currentPtr, sizeof(Int)))
        currentPtr += sizeof(Int)
        print("stroke count:\(strokeCount)")
        return strokeCount
    }
    var lastTSI:ToolStringInfo = ToolStringInfo()
    var lastTVI:ToolValueInfo = ToolValueInfo()
    
    func parseToolStringInfo(data:NSData)->ToolStringInfo!
    {
        //toolName :string
        
        let toolString = parseString()
        if(toolString == nil)
        {
            return nil
        }
        else
        {
            //brushTexture :string
            let textureString = parseString()
            
            let info = ToolStringInfo(tool: toolString, texture: textureString)
            
            lastTSI = info
            return info
        }
    }
    func parseToolValueInfo(data:NSData)->ToolValueInfo
    {
        let info:ToolValueInfo = parseStruct()
        lastTVI = info
        return info
    }
    
    
}