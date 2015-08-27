//
//  Dialogue.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/21.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit
class Dialogue {
    var dialogueLines:[DialogueLine]!
    init()
    {
        
    }
    func addLine(line:DialogueLine)
    {
        dialogueLines.append(line)
        
    }
}