//
//  FileManager.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/31.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import Foundation
import SwiftGL
import UIKit
class FileManager {
    
    class var instance:FileManager{
        struct Singleton {
            static let instance = FileManager()
        }
        return Singleton.instance
    }
    let nsFileManager:NSFileManager = NSFileManager.defaultManager()
    var dirPath:String!
    var fileNames:[String]!
    
    init ()
    {
        dirPath = getDirPath()
        searchFiles()
    }
    
    func searchFiles()
    {
        fileNames = self.getFileNames() as! [String]
    }
    func getFileNames()->[AnyObject]
    {
        
        let fm = NSFileManager.defaultManager()
        
        let dirContents: [AnyObject]?
        do {
            dirContents = try fm.contentsOfDirectoryAtPath(dirPath)
        } catch _ {
            dirContents = nil
        }
        print("Get file names----------------")
        print(dirContents!)
        
        let extPredicate = NSPredicate(format: "self ENDSWITH '.paw'")
        
        return (dirContents! as NSArray).filteredArrayUsingPredicate(extPredicate)
        
    }
    var currentPtr = 0
    func newFile()
    {
        
    }
    func createPath(filename:String)->String
    {
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
        
        let dir: AnyObject = dirs[0] //documents directory
        let path = dir.stringByAppendingPathComponent(filename);
        return path
    }
    func checkFileExist(path:String)->Bool
    {
        return nsFileManager.fileExistsAtPath(path)
    }
    func loadImg(filename:String)->UIImage!
    {
        
        if let img = UIImage(contentsOfFile: dirPath+"/"+filename.stringByDeletingPathExtension+".png")
        {
            return img
        }
        return nil
        
    }
    func loadPaintArtWork(filename:String)->PaintArtwork!
    {
        let path = createPath(filename)
        print(path)
        if checkFileExist(path)
        {
            let data = readFile(filename)
            currentPtr = 0
            
            let artwork =  PaintArtwork()
            let strokeCount =  parseStrokeCount(data)
            
            for var i=0; i < strokeCount; i++ {
                
                //parse string info
                var tSI = parseToolStringInfo(data)
                var tVI:ToolValueInfo
                if(tSI==nil)
                {
                    tSI = lastTSI
                    tVI = lastTVI
                }
                else
                {
                    tVI = parseToolValueInfo(data)
                }
                
                let stroke = PaintStroke(s: tSI, v: tVI)
                
                parseStrokePointData(stroke, data: data)
                
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
        data.getBytes(&strokeCount, range: NSMakeRange(currentPtr, sizeof(Int)))
        currentPtr += sizeof(Int)
        print("stroke count:\(strokeCount)")
        return strokeCount
    }
    
    var lastTSI:ToolStringInfo = ToolStringInfo()
    var lastTVI:ToolValueInfo = ToolValueInfo()
    
    func parseToolStringInfo(data:NSData)->ToolStringInfo!
    {
        let toolString = parseString(data)
        if(toolString == nil)
        {
            return nil
        }
        else
        {
            let textureString = parseString(data)
            
            let info = ToolStringInfo(tool: toolString, texture: textureString)
            
            //println("Brush string length:\(brushStringLength)")
            //println("Brush string :\(brushString)")
            
            lastTSI = info
            return info
        }
    }
    func parseToolValueInfo(data:NSData)->ToolValueInfo
    {
        var info = ToolValueInfo()
        data.getBytes(&info, range: NSMakeRange(currentPtr, sizeof(ToolValueInfo)))
       
        currentPtr += sizeof(ToolValueInfo)
        lastTVI = info
        return info
    }
    
    func parseStrokePointData(stroke:PaintStroke,data:NSData)
    {
        //4 byte Int, points
        var pointCount:Int = 0
        data.getBytes(&pointCount, range: NSMakeRange(currentPtr, sizeof(Int)))
        currentPtr += sizeof(Int)
        print("point count:\(pointCount)")
        
        // get point data
        let pointData = data.subdataWithRange(NSMakeRange(currentPtr,pointCount*sizeof(PointData)))
        
        //allocate space
        stroke.pointData = [PointData](count: pointCount,repeatedValue: PointData())
        
        //getbyte and copy to
        pointData.getBytes(&stroke.pointData, length: pointCount*sizeof(PointData))
        
        stroke.genPointsFromPointData()
        
        currentPtr += pointCount*sizeof(PointData)
    }
    
//utility
    func parseInt(data:NSData)->Int
    {
        var length:Int = 0
        data.getBytes(&length, range: NSMakeRange(currentPtr, sizeof(Int)))
        currentPtr += sizeof(Int)
        return length
    }
    func parseString(data:NSData)->String!
    {
        let length = parseInt(data)
        
        if(length == -1)
        {
            return nil
        }
        
        let str = NSString(data: data.subdataWithRange(NSMakeRange(currentPtr, length)), encoding: NSUTF8StringEncoding) as String!
        currentPtr += length
        
        return str
    }
    func parseStructArray<T>(data:NSData,inout t:T)
    {
        let length = parseInt(data)
        parseStructArray(data, length: length, t: &t)
    }
    func parseStructArray<T>(data:NSData,length:Int,inout t:T)
    {
        data.getBytes(&t, range: NSMakeRange(currentPtr, length * sizeof(T)))
        currentPtr += length * sizeof(T)
    }
    
    
    /*
    paw format:
    
    Int: number of strokes
    {
        Int: stroke using Tool name length
        VL: tool name String
        {
            Int: number of Points
            VL Vec2:  position
            VL Double: timeinterval
            VL Vec2:  velocity
        }
    }
    
    */
    func savePaintArtWork(artwork:PaintArtwork,filename:String,img:UIImage!)
    {
        
        //let fileHeader = PaintFileHeader()
        var strokes = artwork.strokes
        
        let data:NSMutableData = NSMutableData()
        
        
        data.appendBytes([strokes.count], length: sizeof(Int))
        for var i=0;i<strokes.count; i++
        {
            var pointData = strokes[i].pointData
            
            let length = pointData.count
            
            let strInfo = strokes[i].stringInfo
            
            encodeString(data, str: strInfo.toolName)
            encodeString(data, str: strInfo.brushTexture)
            print("=================")
            print(strokes[i].valueInfo.color.vec)
            
            data.appendBytes(&strokes[i].valueInfo, length: sizeof(ToolValueInfo))
            
            //point length
            data.appendBytes([length], length: sizeof(Int))
            print("point length:\(length)")
            
            //the point infomation byte arrays, vec2[], double[] ,vec2[]
            data.appendBytes(pointData, length: length*sizeof(PointData))
            print("write byte length:\(length*sizeof(PointData))")
        }
        
        let imageData:NSData = UIImagePNGRepresentation(img)!;
        let path = getDirPath()
        
        _ = data.writeToFile(path+"/"+filename+".paw", atomically: true)
        imageData.writeToFile(path+"/"+filename+".png", atomically: true)
        print(path+"/"+filename+".png")
        
        searchFiles()
    }
    func getDirPath()->String!
    {
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) {
            let dir = dirs[0] //documents directory
            //let path = dir.stringByAppendingPathComponent(filename);
            return dir
        }
        return nil
    }
    func encodeString(data:NSMutableData,str:String)
    {
        let length = str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        data.appendBytes([length], length: sizeof(Int))
        data.appendData(str.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    func writeFile(filename:String,data:NSData)
    {
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)  {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(filename);
        
            nsFileManager.fileExistsAtPath(path)
            //writing
            data.writeToFile(path, atomically: false);
            
            
            
        }

    }
    func writeFile(filename:String,content:String)
    {
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(filename);
                        
            do {
                //writing
                try content.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            } catch _ {
            };
        }
    }
    func readFile(filename:String)->NSData!
    {
        var data:NSData
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(filename);
            
            data = NSData(contentsOfFile: path)!
            return data
        }
        else
        {
            print("filemanager: read error")
            return nil
        }
    }
    func readStringFile(filename:String)->String!
    {
        let content:String!
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(filename);
            
            do {
                content = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            } catch _ {
                content = nil
            }
            
            print("filemanager: file content :\(content)")
            
            print(dirs)
        }
        else
        {
            print("filemanager: read error")
            content = "error"
            return nil
        }
        
        return content
    }
    
    
    func deleteFilfe(filename:String)
    {
        do {
            try nsFileManager.removeItemAtPath(dirPath+filename)
        } catch _ {
        }
    }
}