//
//  Revise.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/18.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
struct Revise {
    var title:String
    var description:String
    
    var value:ReviseValueData!
    init(title:String,description:String,timestamp:Double)
    {
        self.title = title
        self.description = description
        self.value = ReviseValueData(timeStamp: timestamp)
    }
}

struct ReviseValueData {
    var timeStamp:Double
}