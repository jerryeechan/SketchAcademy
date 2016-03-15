//
//  PaintManager.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/1.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//
enum PaintMode{
    case Artwork
    case Revision
}
enum ViewingClipType
{
    case Artwork
    case Revision
}
class PaintManager {
    
    weak var paintView:PaintView!
    weak var instructionView:PaintView!
    var openArtworkFileName:String!
    
    let paintRecorder:PaintRecorder
    let masterReplayer:PaintReplayer
    let revisionReplayer:PaintReplayer
    var artwork:PaintArtwork!
    var currentRevisionClip:PaintClip!
    
    //var paintMode:PaintMode = .Artwork
    var currentReplayer:PaintReplayer
    var viewingClipType:ViewingClipType = .Artwork
    
    init(paintView:PaintView)
    {
        self.paintView = paintView
        masterReplayer = PaintReplayer(paintView: paintView)
        paintRecorder = PaintRecorder(canvas: paintView.glContextBuffer)
        revisionReplayer = PaintReplayer(paintView: paintView)
        currentReplayer = masterReplayer
        newArtwork()
    }
    init(paintView:PaintView,instructionView:PaintView)
    {
        self.paintView = paintView
        self.instructionView = instructionView
        paintRecorder = PaintRecorder(canvas: paintView.glContextBuffer)
        masterReplayer = PaintReplayer(paintView: instructionView)
        revisionReplayer = PaintReplayer(paintView: instructionView)
        currentReplayer = masterReplayer
        newArtwork()
    }
    func newArtwork()
    {
        artwork = nil
        artwork = PaintArtwork()
        paintRecorder.setRecordClip(artwork.masterClip)
        masterReplayer.loadClip(artwork.masterClip)
    }
    
    func clear()
    {
        masterReplayer.stopPlay()
        paintView.glContextBuffer.blank()
    }
    func saveArtwork(filename:String,img:UIImage)
    {
        
        //call filemanager to  save the current PaintArtwork with name
        FileManager.instance.savePaintArtWork(filename, artwork: artwork, img: img, noteDict:NoteManager.instance.getNotes())
    }
    func loadArtwork(filename:String)->Bool
    {
        print("Paint Manager loadArtwork", terminator: "")
        //GLContextBuffer.instance.blank()
        //call filemanager to load the file to PaintArtwork
        artwork = FileManager.instance.loadPaintArtWork(filename)
        paintRecorder.setRecordClip(artwork.masterClip)
        masterReplayer.loadClip(artwork.masterClip)
        NoteManager.instance.loadNotes(filename)
        
        if(artwork != nil)
        {
            
            masterReplayer.loadClip(artwork.masterClip)
            masterReplayer.drawAll()
            //playRevisionClip(0)
            return true
        }
        else
        {
            return false
        }
    }
    
    // view mode can watch both revision or play
    // draw 'Main' or 'Revision' have to decide before enter the canvas
    
    func playArtworkClip()
    {
        masterReplayer.loadClip(artwork.masterClip)
        revisionReplayer.stopPlay()
        currentReplayer = masterReplayer
        
        paintView.glContextBuffer.setArtworkMode()
        paintView.display()
        
    }
    func playRevisionClip(clip:PaintClip)
    {
        revisionReplayer.loadClip(clip)
        currentReplayer = revisionReplayer
        masterReplayer.pause()
        paintView.glContextBuffer.setRevisionMode()
        paintView.display()
        
        //revisionReplayer.restart()
    }
    func playRevisionClip(id:Int)
    {
        playRevisionClip(artwork.revisionClips[id]!)
    }
    func playCurrentRevisionClip()
    {
        playRevisionClip(currentRevisionClip)
    }
    
    func artworkDrawModeSetUp()
    {
        //self.paintMode = .Artwork
        paintRecorder.setRecordClip(artwork.masterClip)
        masterReplayer.loadClip(artwork.masterClip)
        
        //OpenGL setting
        paintView.glContextBuffer.setArtworkMode()
    }
    func revisionDrawModeSetUp()
    {
        //self.paintMode = .Revision
        
        let id = NoteManager.instance.selectedButtonIndex
        if(artwork.revisionClips[id] == nil){
            DLog("Revision Clip Branch at \(id) created")
            let newClip = PaintClip(name: "revision",branchAt: id)
            paintRecorder.setRecordClip(newClip)
            artwork.revisionClips[id] = newClip
            currentRevisionClip = newClip
            revisionReplayer.loadClip(newClip)
        }
        else
        {
            DLog("Revision Clip Branch at \(id) exist")
            let clip = artwork.revisionClips[id]
            paintRecorder.setRecordClip(clip!)
            currentRevisionClip = clip
            revisionReplayer.loadClip(clip!)
        }
        
        //OpenGL setting
        paintView.glContextBuffer.setRevisionMode()
        revisionReplayer.drawAll()
        paintView.display()
    }
    
    func revisionDrawModeSwitchToViewMode()
    {
        switch(viewingClipType)
        {
        case .Artwork:
            playArtworkClip()
        case .Revision:
            playCurrentRevisionClip()
        }
    }
    func artworkDrawModeSwitchToViewMode()
    {
        playArtworkClip()
        
        
        currentReplayer.drawAll()
    }
    /*
    func switchToViewMode()
    {
        currentReplayer.currentStrokeID = artwork.currentClip.strokes.count-1
        masterReplayer.loadClip(artwork.masterClip)
        currentReplayer.drawAll()
    }
    */
    
    
    
    
    
    
    func pauseToggle()
    {
        currentReplayer.pauseToggle()
    }
    func doublePlayBackSpeed()
    {
        currentReplayer.doublePlayBackSpeed()
    }
    func restart()
    {
        currentReplayer.restart()
    }
    
    func drawStrokeProgress(strokeID:Int)->Bool
    {
        return currentReplayer.drawStrokeProgress(strokeID)
    }
    func drawProgress(percentage:Float)->Bool
    {
        return currentReplayer.drawProgress(percentage)
    }
    
    func getMasterStrokeID()->Int
    {
        return masterReplayer.currentStrokeID
    }
    func getCurrentStrokeID()->Int
    {
        //print("currentStrokeID: \(currentReplayer.currentStrokeID)")
        return currentReplayer.currentStrokeID
    }
}
