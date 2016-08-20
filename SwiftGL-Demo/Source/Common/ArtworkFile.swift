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
        
        data = NSMutableData()
        DLog("\(artwork.canvasWidth) \(artwork.canvasHeight) \(artwork.artworkType.rawValue)")
        encodeString("VERSION_1")
        encodeStruct(artwork.canvasWidth)
        encodeStruct(artwork.canvasHeight)
        encodeString(artwork.artworkType.rawValue)
        encodeClip(artwork.useMasterClip())
        //encodeStruct(artwork.revisionClips.count)
        
        /*
        for(atStroke,clip) in artwork.revisionClips
        {
            encodeStruct(atStroke)
            encodeClip(clip)
        }
*/
        let path = File.dirpath
        
        data.writeToFile(path+"/"+filename+".paw", atomically: true)
        
    }
    
    func encodeClip(clip:PaintClip)
    {
        let strokes = clip.strokes
        encodeStruct(clip.branchAtIndex)
        encodeStruct(strokes.count)
        for i in 0 ..< strokes.count
        {
            let strInfo = strokes[i].stringInfo
            let pointData = strokes[i].pointData
            
            encodeString(strInfo.toolName)
            encodeString(strInfo.brushTexture)
            encodeStruct(strokes[i].valueInfo)
            encodeStructArray(pointData)
        }
    }
    //---------------------------------------------------------------
    //  load
    //
    //---------------------------------------------------------------
    
    override func delete(filename: String) {
        super.delete(filename+".paw")
    }
    
    
    func load(filename:String)->PaintArtwork!
    {
        
        let path = createPath(filename+".paw")
        
        if checkFileExist(path)
        {
            parseData = readFile(filename+".paw")
            currentPtr = 0
            
            //TODO****
            //should parse width and height of the artwork
            //implement with save file
            //temp: canvaswidth...
            
            
            let version = parseString()
            if version == nil
            {
                currentPtr -= sizeof(Int)
              
            }
            else if version == "VERSION_1"
            {
                let canvasWidth:Int = parseStruct()
                let canvasHeight:Int = parseStruct()
                let artworkType:String = parseString()
            }
            else
            {
                DLog("\(version)")
            }
            /*
            
            */
            let artwork =  PaintArtwork(width: PaintViewController.canvasWidth,height: PaintViewController.canvasHeight)
            
            parseClip(artwork.useMasterClip())
            
            /*
            let revisionCount:Int = parseStruct()
            for var i = 0;i<revisionCount;i++
            {
                let clip = PaintClip(name: "new", branchAt: 0)
                parseClip(clip)
            }
            */
            
            return artwork
        }
        else
        {
            return nil
        }
        //data.getBytes(&brushString, range: )
    }
    func parseClip(clip:PaintClip)->PaintClip
    {
        clip.branchAtIndex = parseStruct()
        
        let strokeCount:Int = parseStruct()
        for _ in 0 ..< strokeCount {
            
            //parse string info, check type
            var tSI = parseToolStringInfo(parseData)
            var tVI:ToolValueInfo
            if(tSI==nil)
            {
                tSI = lastTSI
                tVI = lastTVI
            }
            else
            {
                //valueInfo:ToolValueInfo, get stroke detail
                tVI = parseToolValueInfo(parseData)
            }
            
            let stroke = PaintStroke(s: tSI, v: tVI)
            clip.addPaintStroke(stroke)
            
            
            //some special tool doesn't have points
            if(tSI.toolName=="clear")
            {
                continue
            }
            
            
            //parse pointData:[PointData]
            let pointData:[PointData] = parseStructArray()
            stroke.pointData = pointData
            stroke.genPointsFromPointData()
            
            
        }
        
        return clip
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