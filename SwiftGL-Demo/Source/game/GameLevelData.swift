//
//  GameLevelData.swift
//  SwiftGL
//
//  Created by CSC NTHU on 2015/8/20.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//


class GameLevelData {
    
    var nameSet:[String]
    var positionSet:[Array<Double>]
    
    init(nameArray:[String], positionArray:[Array<Double>]){
        nameSet = nameArray
        positionSet = positionArray
    }
    
    func getNameSet() -> [String]{
        return nameSet
    }
    
    func getPositionSet() -> [Array<Double>]{
        return positionSet
    }
}