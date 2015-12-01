//
//  PaintReplayerRevisionExtension.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/1.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
extension PaintReplayer
{
    
    func playRevision(revision:PaintRevision)
    {
        drawStrokeProgress(revision.startAtStrokeIndex)
    }
    
    func playCurrentRevisionStroke()
    {
        
    }
    
    
}
