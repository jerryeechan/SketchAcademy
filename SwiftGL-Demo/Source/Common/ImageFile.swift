//
//  ImageFile.swift
//  SwiftGL
//
//  Created by jerry on 2015/10/28.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
import SwiftHttp
class ImageFile: File {
    func loadImg(_ filename:String)->UIImage!
    {
        
        if let img = UIImage(contentsOfFile: File.dirpath+"/"+NSString(string: filename).deletingPathExtension+".png")
        {
            return img
        }
        return nil
        
    }
    func loadImgWithExtension(_ filename:String,ext:String)->UIImage!
    {
        if let img = UIImage(contentsOfFile: File.dirpath+"/"+NSString(string: filename).deletingPathExtension+ext)
        {
            return img
        }
        return nil
    }
    func loadImg(_ filename:String, attribute:String = "original")->UIImage!
    {
        switch attribute {
        case "original":
            return loadImgWithExtension(filename, ext: ".png")
        case "thumb":
            return loadImgWithExtension(filename, ext: "thumb.png")
        case "gif":
            return loadImgWithExtension(filename, ext: ".gif")
        default:
            return loadImgWithExtension(filename, ext: ".png")
        }
    }
     
    func saveImg(_ img:UIImage,filename:String)
    {
        
        let imageData:Data = UIImagePNGRepresentation(img)!;
        let filePath = File.dirpath+"/"+filename+".png"
        try? imageData.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
        
    }
    override func delete(_ filename: String) {
        super.delete(filename+".png")
    }
    
}
