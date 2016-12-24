//
//  PaintViewStrokeSelect.swift
//  SwiftGL
//
//  Created by jerry on 2016/5/15.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

extension PaintViewController
{
    func enterSelectStrokeMode(){
        appState = AppState.selectStroke
        
        selectStrokeModeToolBarSetUp()
    }
    func playSeletingStrokes()
    {
        strokeSelecter.isSelectingClip = true
        //strokeSelecter.originalClip = paintManager.artwork.useMasterClip()
        paintManager.artwork.loadClip(strokeSelecter.selectingClip)
            //.drawClip(strokeSelecter.selectingClip)
        
        
        
        //paintView.glDraw()
        _ = removeToolBarButton(reviseDoneButton)
        appState = AppState.viewArtwork
        enterViewMode()
    }
    func selectStrokeModeToolBarSetUp()
    {
        addToolBarButton(reviseDoneButton, atIndex: 0)
        mainToolBar.setItems(toolBarItems, animated: true)
        
    }
    func backToOriginalClip()
    {
        
        paintManager.artwork.useMasterClip()
    }
}
