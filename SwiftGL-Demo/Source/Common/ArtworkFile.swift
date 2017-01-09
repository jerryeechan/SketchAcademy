//
//  ArtworkFile.swift
//  SwiftGL
//
//  Created by jerry on 2015/10/28.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
import GLFramework
public class ArtworkFile:File{

    public override init()
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
    func save(_ filename:String,artwork:PaintArtwork)
    {
        
        data = NSMutableData()
        DLog("\(artwork.canvasWidth) \(artwork.canvasHeight) \(artwork.artworkType.rawValue)")
        //current Version
        encodeString("VERSION_2")
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
        
        data.write(toFile: path+"/"+filename+".paw", atomically: true)
        
        //safe stroke data into text file(json?)
        saveText(filename, artwork: artwork)
    }
    func saveText(_ filename:String,artwork:PaintArtwork)
    {
        
        let clip = artwork.useMasterClip()
        clip.strokeInfoAnalysis()
        let text = clip.strokes.tojsonStrokeInfo
        
        print(text)
        
        do
        {
            try text.write(toFile: File.dirpath+"/zana_data/"+filename+"Text.txt", atomically: false, encoding: String.Encoding.utf8)
        }
        catch
        {
            print("save to text error")
        }
        
    }
    
    func encodeClip(_ clip:PaintClip)
    {
        let strokes = clip.strokes
        encodeStruct(clip.branchAtIndex)
        encodeStruct(strokes.count)
        for i in 0 ..< strokes.count
        {
            let strInfo = strokes[i].stringInfo
            let pointData = strokes[i].pointData
            
            encodeStruct(strokes[i].startTime)
            encodeString(strInfo.toolName)
            encodeString(strInfo.brushTexture)
            encodeStruct(strokes[i].valueInfo)
            encodeStructArray(pointData)
        }
    }
    override public func delete(_ filename: String) {
        super.delete(filename+".paw")
    }
    
    var fileVersion:String!
    
    //---------------------------------------------------------------
    //  load
    //
    //---------------------------------------------------------------
    
    func load(_ filename:String)->PaintArtwork!
    {
        
        let path = createPath(filename+".paw")
        
        if checkFileExist(path)
        {
            parseData = readFile(filename+".paw") as NSData!
            currentPtr = 0
            
            //TODO****
            //should parse width and height of the artwork
            //implement with save file
            //temp: canvaswidth...
            
            
            let version = parseString()!
            fileVersion = version
            var canvasWidth:Int = 2048
            var canvasHeight:Int = 1567
            if version == nil
            {
                currentPtr -= MemoryLayout<Int>.size
              
            }
            switch version{
            case "VERSION_1","VERSION_2":
                canvasWidth = parseStruct()
                canvasHeight = parseStruct()
                let artworkType:String = parseString()
            default:
                DLog("\(version)")
                break
            }
            /*
            
            */
            //let artwork =  PaintArtwork(width: PaintViewController.canvasWidth,height: PaintViewController.canvasHeight)
            let artwork =  PaintArtwork(width: canvasWidth,height: canvasHeight)
            
            _ = parseClip(artwork.useMasterClip())
            
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
    func parseClip(_ clip:PaintClip)->PaintClip
    {
        clip.branchAtIndex = parseStruct()
        
        let strokeCount:Int = parseStruct()
        for _ in 0 ..< strokeCount {
            var time:Double = 0.0
            switch(fileVersion)
            {
                case "VERSION_2":
                    time = parseStruct()
                default:
                    break
            }
            //parse string info, check type
            var tSI = parseToolStringInfo(parseData as Data)
            var tVI:ToolValueInfo
            if(tSI==nil)
            {
                tSI = lastTSI
                tVI = lastTVI
            }
            else
            {
                //valueInfo:ToolValueInfo, get stroke detail
                tVI = parseToolValueInfo(parseData as Data)
            }
            
            let stroke = PaintStroke(s: tSI!, v: tVI,startTime:time)
            
            
            
            //some special tool doesn't have points
            if(tSI?.toolName=="clear")
            {
                clip.addPaintStroke(stroke)
                continue
                
            }
            
            //parse pointData:[PointData]
            let pointData:[PointData] = parseStructArray()
            stroke.pointData = pointData
            stroke.genPointsFromPointData()
            clip.addPaintStroke(stroke)
        }
        
        return clip
    }
    var lastTSI:ToolStringInfo = ToolStringInfo()
    var lastTVI:ToolValueInfo = ToolValueInfo()
    
    func parseToolStringInfo(_ data:Data)->ToolStringInfo!
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
            
            let info = ToolStringInfo(tool: toolString!, texture: textureString!)
            
            lastTSI = info
            return info
        }
    }
    func parseToolValueInfo(_ data:Data)->ToolValueInfo
    {
        let info:ToolValueInfo = parseStruct()
        lastTVI = info
        return info
    }
}
