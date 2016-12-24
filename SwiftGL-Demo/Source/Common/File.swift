//
//  File.swift
//  SwiftGL
//
//  Created by jerry on 2015/10/28.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
func binarytotype <T> (_ value: [UInt8], _: T.Type) -> T {
    return value.withUnsafeBufferPointer {
        UnsafeRawPointer($0.baseAddress!).load(as: T.self)
    }
}
open class File {
    
    open static var nsFileManager:Foundation.FileManager = Foundation.FileManager.default
    
    public var currentPtr = 0

    //utility
    public var data:NSMutableData!
    public var parseData:NSData!
//----------------------------------------
//start of parsing
    public init()
    {
        
    }
    public func parseInt()->Int
    {
        var length:Int = 0
        parseData.getBytes(&length, range: NSMakeRange(currentPtr, MemoryLayout<Int>.size))
        //parseData.copyBytes(to: [length], from: NSMakeRange(currentPtr, MemoryLayout<Int>.size))
        currentPtr += MemoryLayout<Int>.size
        return length
    }
    public func parseString()->String!
    {
        
        let length:Int = parseStruct()
        //print("parse string \(length)")
        if(length == -1 || length == 0)
        {
            return nil
        }
        
        
        
        let str = NSString.init(data: parseData.subdata(with:NSMakeRange(currentPtr,length)), encoding: String.Encoding.utf8.rawValue)
        currentPtr += length
        
        return str as! String
    }
    public func parseStruct<T:Initable>()->T{
        var t:T = T()
        //print("currentPtr \(currentPtr) parse struct \(strideof(T))")
        
        parseData.getBytes(&t, range: NSMakeRange(currentPtr, MemoryLayout<T>.size))
        //parseData.copyBytes(to: &t, from: NSMakeRange(currentPtr, MemoryLayout<T>.stride))
        currentPtr += MemoryLayout<T>.size
        print(t)
        return t
    }
    
    public func parseStructArray<T:Initable>()->[T]
    {
        let length = parseInt()

        var array = [T](repeating: T(),count: length)
        ///?????????
        print(MemoryLayout<T>.stride)
        print(MemoryLayout<T>.size)
        parseData.getBytes(&array, range: NSMakeRange(currentPtr,length*MemoryLayout<T>.stride))
        //parseData.copyBytes(to: &array, from: NSMakeRange(currentPtr, length * MemoryLayout<T>.size))
        currentPtr += length * MemoryLayout<T>.size
        return array
    }
//end of parsing
//--------------------------------------------
    
    
    public func encodeString(_ str:String)
    {
        
        let length = str.lengthOfBytes(using: String.Encoding.utf8)
//        print("encode String \(length)")
        data.append([length], length: MemoryLayout<Int>.size)
        data.append(str.data(using: String.Encoding.utf8)!)
    }
    public func encodeStruct<T>(_ value:T)
    {
     //   print("encode Struct \(value):\(strideof(T))")
        data.append([value], length: MemoryLayout<T>.stride)
    }
    public func encodeStructArray<T>(_ t:[T])
    {
        data.append([t.count], length: MemoryLayout<Int>.size)
        data.append(t, length: t.count*MemoryLayout<T>.size)
    }
    
    
    fileprivate static var _dirpath:String!
    public static var dirpath:String{
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

    fileprivate static func getDirPath()->String!
    {
        let dirs = NSSearchPathForDirectoriesInDomains(Foundation.FileManager.SearchPathDirectory.documentDirectory, Foundation.FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        let dir = dirs[0] //documents directory
            //let path = dir.stringByAppendingPathComponent(filename);
        do {
            try Foundation.FileManager.default.createDirectory(atPath: dir+"/zana_data", withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        return dir
    }
    
    //create the file path
    public func createPath(_ filename:String)->String
    {
        let dirs = NSSearchPathForDirectoriesInDomains(Foundation.FileManager.SearchPathDirectory.documentDirectory, Foundation.FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        let dir = dirs[0]//documents directory
        
        
        //path may has problem
        let path = dir.appending("/"+filename);
        return path
    }
    
    public func checkFileExist(_ path:String)->Bool
    {
        return File.nsFileManager.fileExists(atPath: path)
    }
    
    
    
    
    
    
    //######################################################
    /*
    *   read part
    */
    //##################################################
    public func readFile(_ filename:String)->Data!
    {
        var data:Data
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(Foundation.FileManager.SearchPathDirectory.documentDirectory, Foundation.FileManager.SearchPathDomainMask.allDomainsMask, true) {
            let dir = dirs[0] //documents directory
            
            
            let path = NSString(string: dir).appendingPathComponent(filename)
            
            data = try! Data(contentsOf: URL(fileURLWithPath: path))
            return data
        }
        else
        {
            print("filemanager: read error")
            return nil
        }
    }
    public func readStringFile(_ filename:String)->String!
    {
        let content:String!
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(Foundation.FileManager.SearchPathDirectory.documentDirectory, Foundation.FileManager.SearchPathDomainMask.allDomainsMask, true) {
            let dir = dirs[0] //documents directory
            let path = NSString(string: dir).appendingPathComponent(filename);
            
            do {
                content = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
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
    
    
    open func delete(_ filename:String)
    {
        let path = File.dirpath+"/"+filename
        do {
            print("deleting"+path)
            try File.nsFileManager.removeItem(atPath: path)
        } catch _ {
            print("delete error")
        }
    }


}


