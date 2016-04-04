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
import SwiftHttp
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
    func savePaintArtWork(filename:String,artwork:PaintArtwork, img:UIImage,noteDict:[Int:Note])
    {
        let path = File.dirpath+"/"+filename
        
        artworkFile.save(filename, artwork: artwork)
        imageFile.saveImg(img, filename: filename)
        //upload(path+".png")
        //upload(path+".paw")
        noteFile.save(noteDict, filename: filename)
        
        searchFiles()
    }
    func upload(img:UIImage)
    {
        let imageData:NSData = UIImagePNGRepresentation(img)!;
        let fileUrl = NSURL(dataRepresentation: imageData, relativeToURL: nil)
        upload(fileUrl)
    }
    
    func upload(filePath:String)
    {
        
        let fileUrl = NSURL(fileURLWithPath: filePath)
        upload(fileUrl)
    }
    func upload(fileUrl:NSURL)
    {
        do {
            let opt = try HTTP.POST("http://140.114.217.36:3000/artworks/upload", parameters: ["name": "test", "file": Upload(fileUrl: fileUrl)])
            opt.start { response in
                //do things...
                if let err = response.error {
                    DLog("error: \(err.localizedDescription)")
                    
                    return //also notify app of failure as needed
                }
                DLog("opt finished: \(response.description)")
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    func deletePaintArtWork(filename:String)
    {
        artworkFile.delete(filename)
        imageFile.delete(filename)
        noteFile.delete(filename)
        searchFiles()
    }
    
    func loadImg(filename:String)->UIImage
    {
        return imageFile.loadImg(filename)
    }
 
    func loadNotes(filename:String)->[Int:Note]
    {
        return noteFile.load(filename)
    }
    
    init ()
    {
//        dirPath = getDirPath()
        searchFiles()
    }
    func getFileCount()->Int
    {
        return fileNames.count
    }
    func getFileNames()->[String]
    {
        return fileNames
    }
    func getFileName(index:Int)->String
    {
        return fileNames[index]
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
        var fileNames = (dirContents! as NSArray).filteredArrayUsingPredicate(extPredicate) as! [String]
        
        for i in 0 ..< fileNames.count
        {
            fileNames[i] = NSString(string: fileNames[i]).stringByDeletingPathExtension
        }
        
        self.fileNames = fileNames
        return fileNames

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