//
//  ReviseManager.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/25.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation

class ReviseManager {
    class var instance:ReviseManager{
        struct Singleton{
            static let instance = ReviseManager()
        }
        return Singleton.instance
    }
    
    var reviseList:[Revise] = []
    func addRevise(title:String,description:String)
    {
        reviseList.append(Revise(title: title, description: description, timestamp: PaintRecorder.instance.artwork.currentTime))
    }
    
    func saveRevises()
    {
        //FileManager.instance.sa
    }
}