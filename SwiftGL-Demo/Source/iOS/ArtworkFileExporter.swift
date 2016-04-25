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
    func exportGIF(filename:String)
    {
        let property:NSDictionary = [kCGImagePropertyGIFDictionary as NSString:[kCGImagePropertyGIFLoopCount as NSString:0]]
        
        let frameProperties = [kCGImagePropertyGIFDictionary as NSString:[kCGImagePropertyGIFDelayTime as NSString:2]]
        let docDirURL:NSURL
        let fileURL:NSURL
        let destination:CGImageDestination
        do{
            docDirURL = try NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.AllDomainsMask, appropriateForURL: nil, create: true)
            fileURL = docDirURL.URLByAppendingPathComponent("\(filename).gif")
            destination = CGImageDestinationCreateWithURL(fileURL, kUTTypeGIF, 32, nil)!
            for i in 0...100 {
                paintManager.artwork.currentReplayer.drawProgress(Float(i))
                let image = paintView.snapshot
                CGImageDestinationAddImage(destination,image.CGImage!, frameProperties);
            }
            CGImageDestinationSetProperties(destination, property)
            CGImageDestinationFinalize(destination);
            
        }
        catch _ {
            
        }
        
        
        
        
        
        
        
        
        
        
        
    }
}