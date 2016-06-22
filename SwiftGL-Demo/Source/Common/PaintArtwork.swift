//
//  PaintArtwork.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/21.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//
enum ArtworkType:String{
    case Artwork = "Artwork"
    case Tutorial = "Tutorial"
    
}
import Foundation
class PaintArtwork
{
    var artworkType:ArtworkType = .Artwork
    var canvasWidth:Int
    var canvasHeight:Int
    private var _masterClip:PaintClip
    private var _revisionClips:[Int:PaintClip] = [Int:PaintClip]()
    var revisionClips:[Int:PaintClip]{
        get{
            return _revisionClips
        }
    }
    
    var lastClip:PaintClip
    var currentClip:PaintClip
        {
        willSet(newClip)
        {
            if newClip != currentClip
            {
                lastClip = currentClip
                //unbind the stroke change event if the clip has changed
                newClip.onStrokeIDChanged = currentClip.onStrokeIDChanged
                currentClip.onStrokeIDChanged = nil
            }
        }
    }
    var currentRevisionID:Int!
    var isFileExist:Bool = false
    
    var currentNoteIndex:Int = 0
    var currentNote:Note!
    
    init(width:Int,height:Int)
    {
        _masterClip = PaintClip(name: "master",branchAt: 0)
        _masterClip.currentTime = 0
        currentClip = _masterClip
        lastClip = currentClip
        canvasWidth = width
        canvasHeight = height
    }
    func setReplayer(paintView:PaintView,type:ArtworkType = .Artwork)
    {
        self.artworkType = type
        var buffer:GLContextBuffer = paintView.paintBuffer
        if type == .Tutorial
        {
            buffer = paintView.tutorialBuffer
        }
        
        masterReplayer = PaintReplayer(paintView:paintView,context: buffer)
        revisionReplayer = PaintReplayer(paintView:paintView,context: buffer)
        currentReplayer = masterReplayer
    }
    func setUpClips()
    {
        masterReplayer.loadClip(_masterClip)
    }
    func drawAll()
    {
        masterReplayer.drawAll()
    }
    func drawClip(clip:PaintClip)
    {
        _masterClip = clip
        masterReplayer.loadClip(clip)
        masterReplayer.drawAll()
    }
    func setArtworkMode()
    {
        
    }
    func loadCurrentClip()
    {
        masterReplayer.loadClip(currentClip)
        currentReplayer = masterReplayer
    }
    func loadClip(clip:PaintClip)
    {
        currentClip = clip
        masterReplayer.loadClip(clip)
        revisionReplayer.stopPlay()
        currentReplayer = masterReplayer
        masterReplayer.drawAll()
    }
    func loadMasterClip()
    {
        currentClip = _masterClip
        masterReplayer.loadClip(_masterClip)
        revisionReplayer.stopPlay()
        currentReplayer = masterReplayer
    }
    func loadCurrentRevisionClip()
    {
        loadRevisionClip(currentRevisionID)
    }
    func loadRevisionClip(stroke:Int)
    {
        currentRevisionID = stroke
        revisionReplayer.loadClip(_revisionClips[stroke]!)
        masterReplayer.pause()
        currentReplayer = revisionReplayer

    }
    func useClip(clip:PaintClip)->PaintClip
    {
        currentClip = clip
        return currentClip
    }
    func useMasterClip()->PaintClip
    {
        return useClip(_masterClip)
    }
    func useRevisionClip(id:Int)->PaintClip
    {
        return useClip(revisionClips[id]!)
    }
    func addRevisionClip(atStroke:Int)
    {
        let newClip = PaintClip(name: "revision",branchAt: atStroke)
        _revisionClips[atStroke] =  newClip
    }
    
    var masterReplayer:PaintReplayer!
    var revisionReplayer:PaintReplayer!
    var currentReplayer:PaintReplayer!
}