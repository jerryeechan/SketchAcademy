//
//  PaintClip.swift
//  SwiftGL
//
//  Created by jerry on 2015/11/30.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

public enum Operation {
    case clean
}
import SwiftGL
public class PaintClip:NSObject{
    
    //  branch related
   public var strokes:[PaintStroke] = []
   public var redoStrokes:[PaintStroke] = []
    
   public var cleanStrokes:[PaintStroke] = []
   public var op:[Operation] = []
   public var redoOp:[Operation] = []
    
    /**
        not sure need current time or not
     */
    public var currentTime:CFAbsoluteTime = 0
    public var currentPointID:Int = 0
    public var current_vInfo:ToolValueInfo!
    public var currentStrokeID:Int = 0
        {
        didSet{
            handleStrokeIDChanged();
        }
    }

    //    branch related

    public var clipName:String
    public var branchAtIndex:Int = 0
    public var parentClip:PaintClip!
    public var branchClip:Dictionary<String,PaintClip> = Dictionary<String,PaintClip>()
    public weak var strokeDelegate:StrokeProgressChangeDelegate!
    
    func defaultOnStrokeIDChanged(a:Int,b:Int)->Void
    {
        
    }
    
    public init(name:String,branchAt:Int)
    {
        self.clipName = name
        self.branchAtIndex = branchAt
        //self.strokeDelegate = delegate
        //self.onStrokeIDChanged = defaultOnStrokeIDChanged
        super.init()
        
        
    }
    
    func addStep()
    {
        
    }
    public func addPaintStroke(_ stroke:PaintStroke)
    {
        if(stroke.pointData.count>0 )
        {
            currentTime = (stroke.pointData.last?.timestamps)!
        }
        else
        {
            currentTime = stroke.startTime;
        }
        
        strokes.append(stroke)
        
        currentStrokeID = strokes.count
        //DLog("\(currentStrokeID)")
    }
    public func addBranchClip(_ branchName:String,branchAt:Int)
    {
        branchClip[branchName] = PaintClip(name: branchName,branchAt: branchAt)
        branchClip[branchName]?.parentClip = self
        
    }
    public func switchToBranch(_ branchName:String)
    {
        
    }
    //when user start drawing again, remove all the redo strokes and can't
    public func cleanRedos()
    {
        redoStrokes = []
        redoOp = []
        cleanStrokes = []
        op = []
    }
    
    //enum ClipState{case Drawing,case Cleaned,case UndoCleaned}
    public func clean()
    {
        cleanStrokes = strokes
        strokes = []
        currentStrokeID = 0
        op += [Operation.clean]
    }
    public func undoClean()
    {
        strokes = cleanStrokes
        redoStrokes = []
        redoOp += [Operation.clean]
    }
    public func undo()
    {
        
        if strokes.count > 0
        {
            redoStrokes.append(strokes.removeLast())
        }
        
        
    }
    public func redo()->PaintStroke!
    {
        
        if redoStrokes.count > 0
        {
            strokes.append(redoStrokes.removeLast())
            currentStrokeID += 1
            return strokes.last!
        }
        return nil
        
    }
     var onStrokeIDChanged:((_ currentStrokeID:Int,_ totalStrokeCount:Int)->Void)? = nil
//    var onStrokeIDChanged:(currentStrokeID:Int,totalStrokeCount:Int)->Void
    //var onStrokeIDChanged:(Int,Int)->Void
    //var onStrokeIDChanged:(Int,Int)->Void
    
    func handleStrokeIDChanged()
    {
        if (strokeDelegate != nil)
        {
            strokeDelegate.onStrokeProgressChanged(currentStrokeID, totalStrokeCount: strokes.count + redoStrokes.count)
            //PaintViewController.instance.onStrokeProgressChanged(currentStrokeID, totalStrokeCount: strokes.count + redoStrokes.count)
            
        }
        //onStrokeIDChanged(currentStrokeID, strokes.count + redoStrokes.count)
        
        //DLog("current\(currentStrokeID) strokes:\(strokes.count) redo:\(redoStrokes.count)")

    }
    var bvhTree:BVHTree = BVHTree()
    public func buildBVHTree()
    {
        bvhTree.buildTree(strokes)
    }
    public func selectStrokes(_ point:Vec2)->[PaintStroke]
    {
        return bvhTree.searchNodes(point) as! [PaintStroke]
    }
    deinit
    {
        DLog("clip deinit")
    }
    
    public func strokeInfoAnalysis()
    {
        var eraserCount = 0
        var pencilCount = 0
        
        var eraserTime = 0.0
        var pencilTime = 0.0
        
        var pencilLength = 0
        var eraserLength = 0
        
        
        for stroke in strokes {
            if stroke.stringInfo.toolName=="eraser"
            {
                eraserCount += 1
                eraserTime += (stroke.pointData.last?.timestamps)!
            }
            else if stroke.stringInfo.toolName=="pen"
            {
                pencilCount += 1
                pencilTime += (stroke.pointData.last?.timestamps)!
            }
            else
            {
                print("other tool\(stroke.stringInfo.toolName)")
                print("zz")
            }
            
        }
        print("Stroke Analysis:\(pencilCount) \(eraserCount) \(pencilTime) \(eraserTime)")
    }
}

public protocol StrokeProgressChangeDelegate:class {
    func onStrokeProgressChanged(_ currentStrokeID:Int,totalStrokeCount:Int);
    
}
