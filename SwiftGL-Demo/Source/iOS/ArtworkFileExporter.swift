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
        upload(fileURL)
    }
    func exportGIF(filename:String)->NSURL!
    {
        let property = [kCGImagePropertyGIFDictionary as String:[kCGImagePropertyGIFLoopCount as String:1]]
        
        let frameProperties = [kCGImagePropertyGIFDictionary as String:[kCGImagePropertyGIFDelayTime as String:NSNumber(float: 0.1)]]
        let docDirURL:NSURL
        let fileURL:NSURL
        let destination:CGImageDestination
        do{
            let frameCount = 100
            docDirURL = try NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.AllDomainsMask, appropriateForURL: nil, create: true)
            fileURL = docDirURL.URLByAppendingPathComponent("\(filename).gif")
            destination = CGImageDestinationCreateWithURL(fileURL, kUTTypeGIF, frameCount+5, nil)!
            
            for i in 1...frameCount {
                paintManager.artwork.currentReplayer.drawProgress(Float(i)/Float(frameCount))
                paintView.setNeedsDisplay()
                let image = scaleImage(paintView.snapshot, scale: 0.4)
                CGImageDestinationAddImage(destination,image.CGImage!, frameProperties);
            }
            for _ in 0..<5
            {
                let image = scaleImage(paintView.snapshot, scale: 0.4)
                CGImageDestinationAddImage(destination,image.CGImage!, frameProperties)
            }
            CGImageDestinationSetProperties(destination, property)
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