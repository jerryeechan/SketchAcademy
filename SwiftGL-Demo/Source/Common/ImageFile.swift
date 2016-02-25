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
    func loadImg(filename:String)->UIImage!
    {
        
        if let img = UIImage(contentsOfFile: File.dirpath+"/"+NSString(string: filename).stringByDeletingPathExtension+".png")
        {
            return img
        }
        return nil
        
    }
    func saveImg(img:UIImage,filename:String)
    {
        let imageData:NSData = UIImagePNGRepresentation(img)!;
        let filePath = File.dirpath+"/"+filename+".png"
        imageData.writeToFile(filePath, atomically: true)
        
    }
    override func delete(filename: String) {
        super.delete(filename+".png")
    }
    
}