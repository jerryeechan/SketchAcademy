//
//  Revise.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/18.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
struct Note{
    var title:String
    var description:String
    
    var value:NoteValueData!
    init(title:String,description:String,strokeIndex:Int)
    {
        self.title = title
        self.description = description
        self.value = NoteValueData(strokeIndex: strokeIndex,timestamps: 0)
    }
    init(title:String,description:String,valueData:NoteValueData)
    {
        self.title = title
        self.description = description
        self.value = valueData
    }
}

struct NoteValueData:Initable {
    var strokeIndex:Int
    var timestamps:NSTimeInterval
    init()
    {
        strokeIndex = 0
        timestamps = 0
    }
    init(strokeIndex:Int,timestamps:NSTimeInterval){
        self.strokeIndex = strokeIndex
        self.timestamps = timestamps
    }
}