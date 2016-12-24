//
//  PaintManager.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/1.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//
enum PaintMode{
    case artwork
    case revision
}
enum ViewingClipType
{
    case artwork
    case revision
}
import GLFramework
class PaintManager {
    
    weak var paintView:PaintView!
    
    var openArtworkFileName:String!
    
    var artwork:PaintArtwork!
    var tutorialArtwork:PaintArtwork!
    
    var replayTargetArtwork:PaintArtwork!
    
    let paintRecorder:PaintRecorder
    var currentReplayer:PaintReplayer!
    
    var viewingClipType:ViewingClipType = .artwork
    
    
    init(paintView:PaintView)
    {
        self.paintView = paintView
        switch PaintViewController.appMode
        {
        case ApplicationMode.instructionTutorial:
            paintRecorder = PaintRecorder(canvas: paintView.paintBuffer)
            
        default:
            paintRecorder = PaintRecorder(canvas: paintView.paintBuffer)
            //artwork.setReplayer(paintView)
            
        }
        
    }
    
    
    
    
    func newArtwork(_ width:Int,height:Int)
    {
        artwork = nil
        artwork = PaintArtwork(width: width,height: height)
        let clip = artwork.useMasterClip()
        paintRecorder.setRecordClip(clip)
        artwork.setReplayer(paintView)
        
        currentReplayer = artwork.masterReplayer
        replayTargetArtwork = artwork
        artwork.masterReplayer.loadClip(clip)
        //masterReplayer.loadClip(clip)
    }
    
    func clear()
    {
        artwork.masterReplayer.stopPlay()
        paintView.paintBuffer.blank()
    }
    func saveArtwork(_ filename:String,img:UIImage)
    {
        
        //call filemanager to  save the current PaintArtwork with name
        FileManager.instance.savePaintArtWork(filename, artwork: artwork, img: img, notes:NoteManager.instance.getNoteArray())
        
    }
    func loadArtwork(_ filename:String)->Bool
    {
        NoteManager.instance.loadNotes(filename)
        switch PaintViewController.appMode
        {
        case .artWorkCreation:
            artwork = FileManager.instance.loadPaintArtWork(filename)
            artwork.setReplayer(paintView)
            artwork.loadMasterClip()
            artwork.masterReplayer.drawAll()
            currentReplayer = artwork.masterReplayer
        case .createTutorial:
            artwork = FileManager.instance.loadPaintArtWork(filename)
            artwork.setReplayer(paintView)
            artwork.loadMasterClip()
            artwork.masterReplayer.drawAll()
            currentReplayer = artwork.masterReplayer
            //add create tutorial
            break
        case .instructionTutorial:
            artwork = PaintArtwork(width: PaintViewController.canvasWidth/2,height:PaintViewController.canvasHeight)
            artwork.setReplayer(paintView)
            artwork.loadMasterClip()
            
            tutorialArtwork = FileManager.instance.loadPaintArtWork(filename)
            
            
            tutorialArtwork.setReplayer(paintView,type: ArtworkType.Tutorial)
            tutorialArtwork.loadMasterClip()
            currentReplayer = tutorialArtwork.masterReplayer
            tutorialGotoStep(0)
            break
        }
        
        
        
        
        //instructionTutorial.setReplayer(paintView)
        if(artwork != nil)
        {
            //draw all
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
        artwork.loadCurrentClip()
        paintView.paintBuffer.setArtworkMode()
        paintView.display()
        
    }
    func playRevisionClip(_ id:Int)
    {
        artwork.loadRevisionClip(id)
        paintView.paintBuffer.setRevisionMode()
        paintView.display()
        
        //revisionReplayer.restart()
    }

    
    func playCurrentRevisionClip()
    {
        artwork.loadCurrentRevisionClip()
        paintView.paintBuffer.setRevisionMode()
        paintView.display()
    }
    
    func artworkDrawModeSetUp()
    {
        //self.paintMode = .Artwork
        let clip = artwork.useMasterClip()
        paintRecorder.setRecordClip(clip)
        artwork.masterReplayer.loadClip(clip)
        
        //OpenGL setting
        paintView.paintBuffer.setArtworkMode()
    }
    func revisionDrawModeSetUp()
    {
        //self.paintMode = .Revision
        
        let id = NoteManager.instance.selectedButtonIndex
        if(artwork.revisionClips[id!] == nil){
            DLog("Revision Clip Branch at \(id) created")
            artwork.addRevisionClip(id!)
            let newClip = artwork.useRevisionClip(id!)
            paintRecorder.setRecordClip(newClip)
            artwork.loadRevisionClip(id!)
        }
        else
        {
            DLog("Revision Clip Branch at \(id) exist")
            let clip = artwork.revisionClips[id!]
            paintRecorder.setRecordClip(clip!)
            artwork.loadRevisionClip(id!)
        }
        
        //OpenGL setting
        paintView.paintBuffer.setRevisionMode()
        artwork.revisionReplayer.drawAll()
        paintView.glDraw()
    }
    
    func revisionDrawModeSwitchToViewMode()
    {
        switch(viewingClipType)
        {
        case .artwork:
            playArtworkClip()
        case .revision:
            playCurrentRevisionClip()
        }
        
    }
    func artworkDrawModeSwitchToViewMode()
    {
        playArtworkClip()
        artwork.masterReplayer.drawAll()
        paintView.glDraw()
    }
    /*
    func switchToViewMode()
    {
        currentReplayer.currentStrokeID = artwork.currentClip.strokes.count-1
        masterReplayer.loadClip(artwork.masterClip)
        currentReplayer.drawAll()
    }
    */
    func clean()
    {
        artwork.currentClip.clean()
        paintView.paintBuffer.blank()
        paintView.glDraw()
        
    }
    
    //return if still can undo
    func undo()
    {
        let currentClip = artwork.currentClip
        DLog("\(currentClip.strokes.count) \(currentClip.currentStrokeID)")
        
        if(currentClip.op.count > 0)
        {
            let op = currentClip.op.removeLast()
            switch op {
            case Operation.clean:
                currentClip.undoClean()
                artwork.currentReplayer.drawAll()
                paintView.glDraw()
            default:
                break
            }
        }
        else
        {
            //no op just undo stroke
            currentClip.undo()
            artwork.currentReplayer.drawCurrentStrokeProgress(-1)
        }
    }
    
    func redo()
    {
        let currentClip = artwork.currentClip
        //currentReplayer.drawCurrentStrokeProgress(1)
        if currentClip.redoOp.count > 0
        {
            let op = currentClip.redoOp.removeLast()
            switch op{
            case Operation.clean:
                clean()
                DLog("\(artwork.currentClip.currentStrokeID) \(artwork.currentClip.strokes.count) \(currentClip.redoOp)")
            default:
                break
            }
        }
        else{
            let stroke = artwork.currentClip.redo()
            DLog("\(artwork.currentClip.currentStrokeID) \(artwork.currentClip.strokes.count)")
            if stroke != nil
            {
                paintView.paintBuffer.drawStroke(stroke!, layer: 0)
                paintView.glDraw()
            }
            else{
                DLog("something wrong")
            }

        }
        
        
        
    }
    func pause()
    {
        artwork.currentReplayer.pause()
    }
    
    func pauseToggle()
    {
        artwork.currentReplayer.pauseToggle()
    }
    func doublePlayBackSpeed()
    {
        artwork.currentReplayer.doublePlayBackSpeed()
    }
    func restart()
    {
        artwork.currentReplayer.restart()
    }
    
    func drawStrokeProgress(_ strokeID:Int)->Bool
    {
        return artwork.currentReplayer.drawStrokeProgress(strokeID)
    }
    func drawProgress(_ percentage:Float)->Bool
    {
        
        return artwork.currentReplayer.drawProgress(percentage)
    }
    func getCurrentStrokeID()->Int
    {
        //print("currentStrokeID: \(currentReplayer.currentStrokeID)")
        
        return artwork.currentClip.currentStrokeID
    }
    
    //tutorial replay
    func tutorialNextStep()->Bool
    {
        tutorialArtwork.currentNoteIndex += 1
        tutorialGotoStep(tutorialArtwork.currentNoteIndex)
        if tutorialArtwork.currentNoteIndex == NoteManager.instance.noteCount - 1
        {
            //step done
            return false
        }
        else
        {
            return true
        }
    }
    func tutorialLastStep()->Bool
    {
        tutorialArtwork.currentNoteIndex -= 1
        tutorialGotoStep (tutorialArtwork.currentNoteIndex)
        if tutorialArtwork.currentNoteIndex == 0
        {
            //step done
            return false
        }
        else
        {
            return true
        }
        
    }
    
    //draw to the step, pause the player
    func tutorialGotoStep(_ step:Int)
    {
        let note = NoteManager.instance.getOrderedNote(step)
        if note != nil
        {
            tutorialArtwork.currentNote = note
            tutorialArtwork.currentReplayer.drawStrokeProgress((note?.value.strokeIndex)!)
            
        }
    }
    func tutorialToggle()
    {
        tutorialArtwork.currentReplayer.pauseToggle()
        
    }
    func tutorialRestart()
    {
        let note = tutorialArtwork.currentNote;
        tutorialArtwork.currentReplayer.drawStrokeProgress((note?.value.strokeIndex)!)
    }
}
