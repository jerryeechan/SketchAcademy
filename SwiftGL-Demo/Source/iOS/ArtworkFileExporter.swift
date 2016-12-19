//
//  ArtworkFileExporter.swift
//  SwiftGL
//
//  Created by jerry on 2016/4/9.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
import ImageIO
import MobileCoreServices
import SwiftGL
extension PaintViewController {
    func exportGIF()
    {
        if(fileName==nil)
        {
            fileName = "masterpiece"
        }
        let fileURL = exportGIF(fileName)
        upload(fileURL!)
    }
    func exportGIF(_ filename:String)->URL!
    {
        let property = [kCGImagePropertyGIFDictionary as String:[kCGImagePropertyGIFLoopCount as String:1]]
        
        let frameProperties = [kCGImagePropertyGIFDictionary as String:[kCGImagePropertyGIFDelayTime as String:NSNumber(value: 0.1 as Float)]]
        let docDirURL:URL
        let fileURL:URL
        let destination:CGImageDestination
        do{
            let frameCount = 100
            docDirURL = try Foundation.FileManager.default.url(for: Foundation.FileManager.SearchPathDirectory.documentDirectory, in: Foundation.FileManager.SearchPathDomainMask.allDomainsMask, appropriateFor: nil, create: true)
            fileURL = docDirURL.appendingPathComponent("\(filename).gif")
            destination = CGImageDestinationCreateWithURL(fileURL as CFURL, kUTTypeGIF, frameCount+5, nil)!
            
            for i in 1...frameCount {
                paintManager.artwork.currentReplayer.drawProgress(Float(i)/Float(frameCount))
                paintView.setNeedsDisplay()
                let img = scaleImage(image: paintView.snapshot, scale: 0.4)
                DLog("\(img.size)")
                CGImageDestinationAddImage(destination,img.cgImage!, frameProperties as CFDictionary?);
                
            }
            for _ in 0..<5
            {
                let img = scaleImage(image: paintView.snapshot, scale: 0.4)
                CGImageDestinationAddImage(destination,img.cgImage!, frameProperties as CFDictionary?)
            }
            DLog("render done")
            CGImageDestinationSetProperties(destination, property as CFDictionary?)
            if (!CGImageDestinationFinalize(destination))
            {
                 print("fail")
            }
            return fileURL
            
        }
        catch _ {
            
        }
        return nil
    }
}
