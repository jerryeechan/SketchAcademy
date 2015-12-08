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
    
    class var instance:PaintManager{
        struct Singleton{
            static let instance = PaintManager()
        }
        return Singleton.instance
    }
    
    var openArtworkFileName:String!
    
    let paintRecorder:PaintRecorder = PaintRecorder()
    let masterReplayer:PaintReplayer = PaintReplayer()
    let revisionReplayer:PaintReplayer = PaintReplayer()
    var artwork:PaintArtwork!
    var currentRevisionClip:PaintClip!
    
    //var paintMode:PaintMode = .Artwork
    var currentReplayer:PaintReplayer
    var viewingClipType:ViewingClipType = .Artwork
    
    init()
    {
        currentReplayer = masterReplayer
        newArtwork()
    }
    func newArtwork()
    {
        artwork = nil
        artwork = PaintArtwork()
        paintRecorder.recordClip = artwork.masterClip
        
    }
    
    func clear()
    {
        masterReplayer.stopPlay()
        GLContextBuffer.instance.blank()
        GLContextBuffer.instance.display()
    }
    func saveArtwork(filename:String,img:UIImage)
    {
        
        //call filemanager to  save the current PaintArtwork with name
        FileManager.instance.savePaintArtWork(filename, artwork: artwork, img: img, noteDict:NoteManager.instance.getNotes())
    }
    func loadArtwork(filename:String)->Bool
    {
        print("Paint Manager loadArtwork")
        GLContextBuffer.instance.blank()
        //GLContextBuffer.instance.display()
        //call filemanager to load the file to PaintArtwork
        artwork = FileManager.instance.loadPaintArtWork(filename)
        paintRecorder.recordClip = artwork.masterClip
        NoteManager.instance.loadNotes(filename)
        
        if(artwork != nil)
        {
            
            masterReplayer.loadClip(artwork.masterClip)
            drawAll()
            //playRevisionClip(0)
            return true
        }
        else
        {
            return false
        }
        
    }
    

    
    
    /*
    func enterViewMode(paintMode:PaintMode)
    {
        switch(paintMode)
        {
        case .Artwork:
            paintRecorder.recordClip = artwork.masterClip
            
        case .Revision:
            paintRecorder.recordClip = artwork.revisionClips[0]
        }
    }
*/
    
    // view mode can watch both revision or play
    // draw 'Main' or 'Revision' have to decide before enter the canvas
    
    func playArtworkClip()
    {
        masterReplayer.loadClip(artwork.masterClip)
        currentReplayer = masterReplayer
        
        
        GLRenderTextureFrameBuffer.instance.revisionLayer.enabled = false
        GLRenderTextureFrameBuffer.instance.selectLayer(0)
        revisionReplayer.stopPlay()
        GLRenderTextureFrameBuffer.instance.setAllLayerAlpha(1)
        //masterReplayer.resume()
    }
    func playRevisionClip(clip:PaintClip)
    {
        revisionReplayer.loadClip(clip)
        currentReplayer = revisionReplayer
        
        GLRenderTextureFrameBuffer.instance.revisionLayer.enabled = true
        GLRenderTextureFrameBuffer.instance.setAllLayerAlpha(0.5)
        GLRenderTextureFrameBuffer.instance.selectRevisionLayer()
        masterReplayer.pause()
        GLContextBuffer.instance.display()
        
        
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
        paintRecorder.recordClip = artwork.masterClip
        
        
        //OpenGL setting
        GLRenderTextureFrameBuffer.instance.revisionLayer.enabled = false
        GLRenderTextureFrameBuffer.instance.selectLayer(0)
        GLRenderTextureFrameBuffer.instance.setAllLayerAlpha(1)
    }
    func revisionDrawModeSetUp()
    {
        //self.paintMode = .Revision
        
        let id = getMasterStrokeID()
        if(artwork.revisionClips[id] == nil){
            let newClip = PaintClip(name: "revision",branchAt: id)
            paintRecorder.recordClip = newClip
            currentRevisionClip = newClip
        }
        else
        {
            paintRecorder.recordClip = artwork.revisionClips[id]
            currentRevisionClip = artwork.revisionClips[id]
        }
        //OpenGL setting
        GLRenderTextureFrameBuffer.instance.revisionLayer.enabled = true
        GLRenderTextureFrameBuffer.instance.setAllLayerAlpha(0.5)
        GLRenderTextureFrameBuffer.instance.selectRevisionLayer()
        GLContextBuffer.instance.display()
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
    func drawAll()
    {
        print("Paint Manager draw all")
        masterReplayer.drawAll()
    }
    func getMasterStrokeID()->Int
    {
        return masterReplayer.currentStrokeID
    }
    func getCurrentStrokeID()->Int
    {
        print("currentStrokeID: \(currentReplayer.currentStrokeID)")
        return currentReplayer.currentStrokeID
    }
    
    func setProgressSlider(slider:UISlider)
    {
        masterReplayer.progressSlider = slider
        revisionReplayer.progressSlider = slider
    }
    
}
