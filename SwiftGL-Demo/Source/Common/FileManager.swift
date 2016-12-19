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
import PaintStrokeData
func uploadToGiphy(_ fileUrl:URL)
{
    do {
        let opt = try HTTP.POST("http://upload.giphy.com/v1/gifs", parameters: ["api_key": "dc6zaTOxFJmzC", "file": Upload(fileUrl: fileUrl)])
        opt.start { response in
            //do things...
            if let err = response.error {
                DLog("error: \(err.localizedDescription)")
                
                return //also notify app of failure as needed
            }
            
            DLog("opt finished: \(response)")
            
        }
    } catch let error {
        print("got an error creating the request: \(error)")
    }
 
}
func upload(_ fileUrl:URL)
{
    do {
        print(Upload(fileUrl: fileUrl))
        let opt = try HTTP.POST("http://140.114.237.192:3000/artworks/upload", parameters: ["name": "test", "file": Upload(fileUrl: fileUrl)])
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
    fileprivate var fileNames:[String]!
    
    func loadPaintArtWork(_ filename:String)->PaintArtwork
    {
        return artworkFile.load(filename)
    }
    func copyFile(_ filename:String)
    {
        for ext in [".nt",".paw" ,".png"]
        {
            do {
                try Foundation.FileManager.default.copyItem(atPath: File.dirpath+"/"+filename+ext, toPath: File.dirpath+"/"+filename+"copy"+ext)
            }catch
            {
                
            }
        }
    }
    func savePaintArtWork(_ filename:String,artwork:PaintArtwork, img:UIImage,notes:[Note])
    {
        //let path = File.dirpath+"/"+filename
        
        artworkFile.save(filename, artwork: artwork)
        imageFile.saveImg(scaleImage(image: img, scale: 0.2), filename: filename)
        imageFile.saveImg(img, filename: filename+"_ori")
        //upload(path+".png")
        //upload(path+".paw")
        noteFile.save(notes, filename: filename)
        
        searchFiles()
    }
    
    func uploadImage(_ img:UIImage)
    {
        let imageData:Data = UIImagePNGRepresentation(img)!;
        let fileUrl = URL(dataRepresentation: imageData, relativeTo: nil)
        upload(fileUrl!)
    }
    
    func uploadFilePath(_ filePath:String)
    {
        
        let fileUrl = URL(fileURLWithPath: filePath)
        upload(fileUrl)
    }
        func deletePaintArtWork(_ filename:String)
    {
        artworkFile.delete(filename)
        imageFile.delete(filename)
        noteFile.delete(filename)
        searchFiles()
    }
    
    func loadImg(_ filename:String)->UIImage
    {
        return imageFile.loadImg(filename)
    }
 
    func loadNotes(_ filename:String)->[Int:Note]
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
    func getFileName(_ index:Int)->String
    {
        return fileNames[index]
    }
    func searchFiles()
    {
        fileNames = self.getFileNames(".paw") as! [String]
    }
    func getFileNames(_ format:String)->[AnyObject]
    {
        let fm = Foundation.FileManager.default
        
        let dirContents: [AnyObject]?
        do {
            dirContents = try fm.contentsOfDirectory(atPath: File.dirpath) as [AnyObject]?
        } catch _ {
            dirContents = nil
        }
        print("Get file names----------------")
        
        print(dirContents!)
        
        let extPredicate = NSPredicate(format: "self ENDSWITH '\(format)'")
        var fileNames = (dirContents! as NSArray).filtered(using: extPredicate) as! [String]
        
        for i in 0 ..< fileNames.count
        {
            fileNames[i] = NSString(string: fileNames[i]).deletingPathExtension
        }
        
        self.fileNames = fileNames
        return fileNames as [AnyObject]

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
