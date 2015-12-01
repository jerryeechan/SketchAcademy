//
//  GameLevelData.swift
//  SwiftGL
//
//  Created by CSC NTHU on 2015/8/20.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//


class GameLevelData {
    
    var nameSet:[String]
    
    //the position of the question image and the components
    var positionSet:[CGPoint]
    
    var main:String
    var mainPosition:CGPoint
    var fixPointIndex:Int
    init(main:String,mainPosition:CGPoint,nameArray:[String], positionArray:[CGPoint],fixPointIndex:Int){
        self.main = main
        self.mainPosition = mainPosition
        self.fixPointIndex = fixPointIndex
        nameSet = nameArray
        positionSet = positionArray
    }
    func getNameSet() -> [String]{
        return nameSet
    }
    
    func getPositionSet() -> [CGPoint]{
        return positionSet
    }
}