//
//  File.swift
//  SwiftGL
//
//  Created by jerry on 2015/10/28.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
protocol Initable {
    init()
}
extension Int:Initable
{
}
class File {
    
    static var nsFileManager:NSFileManager = NSFileManager.defaultManager()
    
    var currentPtr = 0

    //utility
    var data:NSMutableData!
    var parseData:NSData!
//----------------------------------------
//start of parsing
    func parseInt()->Int
    {
        var length:Int = 0
        parseData.getBytes(&length, range: NSMakeRange(currentPtr, sizeof(Int)))
        currentPtr += sizeof(Int)
        return length
    }
    func parseString()->String!
    {
        let length = parseInt()
        
        if(length == -1)
        {
            return nil
        }
        
        let str = NSString(data: parseData.subdataWithRange(NSMakeRange(currentPtr, length)), encoding: NSUTF8StringEncoding) as String!
        currentPtr += length
        
        return str
    }
    func parseStruct<T:Initable>()->T{
        var t:T = T()
        print("currentPtr \(currentPtr)")
        print(t)
        parseData.getBytes(&t, range: NSMakeRange(currentPtr, sizeof(T)))
        currentPtr += sizeof(T)
        return t
    }
    
    func parseStructArray<T:Initable>()->[T]
    {
        let length = parseInt()

        var array = [T](count:length,repeatedValue:T())
        parseData.getBytes(&array, range: NSMakeRange(currentPtr, length * sizeof(T)))
        currentPtr += length * sizeof(T)
        return array
    }
//end of parsing
//--------------------------------------------
    
    
    func encodeString(str:String)
    {
        let length = str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        data.appendBytes([length], length: sizeof(Int))
        data.appendData(str.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    func encodeStruct<T>(value:T)
    {
        data.appendBytes([value], length: sizeof(T))
    }
    func encodeStructArray<T>(t:[T])
    {
        data.appendBytes([t.count], length: sizeof(Int))
        data.appendBytes(t, length: t.count*sizeof(T))
    }
    
    
    private static var _dirpath:String!
    static var dirpath:String{
        get
        {
            if (_dirpath != nil)
            {
                return _dirpath
            }
            else
            {

                File._dirpath = getDirPath()
                return  File._dirpath
            }
        
        }
    }
    
    //get the saving directory

    private static func getDirPath()->String!
    {
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) {
            let dir = dirs[0] //documents directory
            //let path = dir.stringByAppendingPathComponent(filename);
            return dir
        }
        return nil
    }
    
    //create the file path
    func createPath(filename:String)->String
    {
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
        
        let dir: AnyObject = dirs[0] //documents directory
        let path = dir.stringByAppendingPathComponent(filename);
        return path
    }
    
    func checkFileExist(path:String)->Bool
    {
        return File.nsFileManager.fileExistsAtPath(path)
    }
    
    
    
    
    
    
    //######################################################
    /*
    *   read part
    */
    //##################################################
    func readFile(filename:String)->NSData!
    {
        var data:NSData
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) {
            let dir = dirs[0] //documents directory
            
            
            let path = NSString(string: dir).stringByAppendingPathComponent(filename)
            
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
            let path = NSString(string: dir).stringByAppendingPathComponent(filename);
            
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
    
    
    func delete(filename:String)
    {
        let path = File.dirpath+"/"+filename
        do {
            print("deleting"+path)
            try File.nsFileManager.removeItemAtPath(path)
        } catch _ {
            print("delete error")
        }
    }


}


