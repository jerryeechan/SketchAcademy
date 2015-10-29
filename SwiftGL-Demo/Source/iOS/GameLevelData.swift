//
//  GameLevelData.swift
//  SwiftGL
//
//  Created by CSC NTHU on 2015/8/20.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//


class GameLevelData {
    
    var nameSet:[String]
    var positionSet:[CGPoint]
    
    init(nameArray:[String], positionArray:[CGPoint]){
        
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