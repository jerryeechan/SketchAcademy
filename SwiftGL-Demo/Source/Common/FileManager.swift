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
    
    let artworkFile = ArtworkFile()
    let imageFile = ImageFile()
    let noteFile = NoteFile()
    private var fileNames:[String]!
    
    func loadPaintArtWork(filename:String)->PaintArtwork
    {
        return artworkFile.load(filename)
    }
    func savePaintArtWork(filename:String,artwork:PaintArtwork, img:UIImage,noteList:[Note])
    {
        artworkFile.save(filename, artwork: artwork)
        imageFile.saveImg(img, filename: filename)
        searchFiles()
    }
    
    
    func loadImg(filename:String)->UIImage
    {
        return imageFile.loadImg(filename)
    }
 
    func loadNoteList(filename:String)->[Note]
    {
        return noteFile.load(filename)
    }
    
    init ()
    {
//        dirPath = getDirPath()
        searchFiles()
    }
    
    func getFileNames()->[String]
    {
        return fileNames
    }
    func searchFiles()
    {
        fileNames = self.getFileNames(".paw") as! [String]
    }
    func getFileNames(format:String)->[AnyObject]
    {
        let fm = NSFileManager.defaultManager()
        
        let dirContents: [AnyObject]?
        do {
            dirContents = try fm.contentsOfDirectoryAtPath(File.dirpath)
        } catch _ {
            dirContents = nil
        }
        print("Get file names----------------")
        print(dirContents!)
        
        let extPredicate = NSPredicate(format: "self ENDSWITH '\(format)'")
        
        return (dirContents! as NSArray).filteredArrayUsingPredicate(extPredicate)

    }
    
    
    
    /*
    func writeFile(filename:String,data:NSData)
    {
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)  {
            let dir = dirs[0] //documents directory
            
            let path = NSString(string: dir).stringByAppendingPathComponent(filename);
        
            File.nsFileManager.fileExistsAtPath(path)
            //writing
            data.writeToFile(path, atomically: false);
        }
    }
    func writeFile(filename:String,content:String)
    {
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) {
            let dir = dirs[0] //documents directory
            let path = NSString(string: dir).stringByAppendingPathComponent(filename);
                        
            do {
                //writing
                try content.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            } catch _ {
            };
        }
    }
*/
    
    
    
    
    
}