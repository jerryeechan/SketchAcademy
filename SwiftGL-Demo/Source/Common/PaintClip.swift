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
   var op:[Operation] = []
   var redoOp:[Operation] = []
    
    /**
        not sure need current time or not
     */
    var currentTime:CFAbsoluteTime = 0
    var currentPointID:Int = 0
    var current_vInfo:ToolValueInfo!
   public var currentStrokeID:Int = 0
        {
        didSet{
            handleStrokeIDChanged();
        }
    }

    //    branch related

    var clipName:String
    var branchAtIndex:Int = 0
    var parentClip:PaintClip!
    var branchClip:Dictionary<String,PaintClip> = Dictionary<String,PaintClip>()
    var strokeDelegate:StrokeProgressChangeDelegate!
    
    func defaultOnStrokeIDChanged(a:Int,b:Int)->Void
    {
        
    }
    
    init(name:String,branchAt:Int,delegate:StrokeProgressChangeDelegate)
    {
        self.clipName = name
        self.branchAtIndex = branchAt
        self.strokeDelegate = delegate
        //self.onStrokeIDChanged = defaultOnStrokeIDChanged
        super.init()
        
        
    }
    
    func addStep()
    {
        
    }
    func addPaintStroke(_ stroke:PaintStroke)
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
    func addBranchClip(_ branchName:String,branchAt:Int,delegate:StrokeProgressChangeDelegate)
    {
        branchClip[branchName] = PaintClip(name: branchName,branchAt: branchAt,delegate: delegate)
        branchClip[branchName]?.parentClip = self
    }
    func switchToBranch(_ branchName:String)
    {
        
    }
    //when user start drawing again, remove all the redo strokes and can't
    func cleanRedos()
    {
        redoStrokes = []
        redoOp = []
        cleanStrokes = []
        op = []
    }
    
    //enum ClipState{case Drawing,case Cleaned,case UndoCleaned}
    func clean()
    {
        cleanStrokes = strokes
        strokes = []
        currentStrokeID = 0
        op += [Operation.clean]
    }
    func undoClean()
    {
        strokes = cleanStrokes
        redoStrokes = []
        redoOp += [Operation.clean]
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
        
        DLog("current\(currentStrokeID) strokes:\(strokes.count) redo:\(redoStrokes.count)")

    }
    var bvhTree:BVHTree = BVHTree()
    func buildBVHTree()
    {
        bvhTree.buildTree(strokes)
    }
    func selectStrokes(_ point:Vec2)->[PaintStroke]
    {
        return bvhTree.searchNodes(point) as! [PaintStroke]
    }
    deinit
    {
        DLog("clip deinit")
    }
}

protocol StrokeProgressChangeDelegate {
    func onStrokeProgressChanged(_ currentStrokeID:Int,totalStrokeCount:Int);
    
}
