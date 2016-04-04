//
//  PaintClip.swift
//  SwiftGL
//
//  Created by jerry on 2015/11/30.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

class PaintClip:NSObject{
    
    //  branch related
    var strokes:[PaintStroke] = []
    var redoStrokes:[PaintStroke] = []
    
    
    
    /**
        not sure need current time or not
     */
    var currentTime:CFAbsoluteTime = 0
    var currentPointID:Int = 0
    var current_vInfo:ToolValueInfo!
    var currentStrokeID:Int = 0
        {
        didSet{
            handleStrokeIDChanged();
        }
    }

    //    branch related

    var name:String
    var branchAtIndex:Int = 0
    var parentClip:PaintClip!
    var branchClip:Dictionary<String,PaintClip> = Dictionary<String,PaintClip>()
    
    
    
    init(name:String,branchAt:Int)
    {
        self.name = name
        self.branchAtIndex = branchAt
    }
    func addPaintStroke(stroke:PaintStroke)
    {
        currentTime = (stroke.pointData.last?.timestamps)!
        strokes.append(stroke)
        
        currentStrokeID = strokes.count
        DLog("\(currentStrokeID)")
    }
    func addBranchClip(branchName:String,branchAt:Int)
    {
        branchClip[branchName] = PaintClip(name: branchName,branchAt: branchAt)
        branchClip[branchName]?.parentClip = self
    }
    func switchToBranch(branchName:String)
    {
        
    }
    func cleanRedos()
    {
        redoStrokes = []
    }
    func undo()
    {
        if strokes.count > 0
        {
            redoStrokes.append(strokes.removeLast())
        }
        
        
    }
    func redo()->PaintStroke!
    {
        if redoStrokes.count > 0
        {
            strokes.append(redoStrokes.removeLast())
            currentStrokeID += 1
            return strokes.last!
        }
        return nil
    }
    
    var onStrokeIDChanged:((currentStrokeID:Int,totalStrokeCount:Int)->Void)? = nil
    
    func handleStrokeIDChanged()
    {
        
        if let handler = onStrokeIDChanged{
            DLog("strokes:\(strokes.count) redo:\(redoStrokes.count)")
            handler(currentStrokeID: currentStrokeID, totalStrokeCount: strokes.count + redoStrokes.count)
        }

    }
    deinit
    {
        DLog("clip deinit")
    }
}