//
//  TopToolBar.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/14.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

extension PaintViewController
{
    func removeToolBarButton(button:UIBarButtonItem)->Int!
    {
        let index = toolBarItems.indexOf(button)
        if(index != nil)
        {
            toolBarItems.removeAtIndex(index!)
        }
        return index
        
    }
    func addToolBarButton(button:UIBarButtonItem,atIndex:Int)
    {
        let index = toolBarItems.indexOf(button)
        if(index == nil)
        {
            toolBarItems.insert(button, atIndex: atIndex)
        }
        
    }
    func viewModeToolBarSetUp()
    {
        let index = removeToolBarButton(enterViewModeButton)
        
        
        switch(paintMode)
        {
        case .Artwork:
            addToolBarButton(enterDrawModeButton, atIndex: index)
            addToolBarButton(addNoteButton,atIndex: index)
            //addToolBarButton(addNoteButton, atIndex: index)
        case .Revision:
            removeToolBarButton(reviseDoneButton)
            removeToolBarButton(enterDrawModeButton)
            //addToolBarButton(addNoteButton, atIndex: toolBarItems.count)
            break
            
        }
        
        
        
        mainToolBar.setItems(toolBarItems, animated: true)
        showToolButton.animateHide(0.2)
        
    }
    func artworkDrawModeToolBarSetUp()
    {
        removeToolBarButton(reviseDoneButton)
        removeToolBarButton(addNoteButton)
        //removeToolBarButton(addNoteButton)
        removeToolBarButton(enterDrawModeButton)
        addToolBarButton(enterViewModeButton, atIndex: toolBarItems.count)
        mainToolBar.setItems(toolBarItems, animated: true)
        showToolButton.animateShow(0.2)
    }
    
    func revisionDrawModeToolBarSetUp()
    {
        //reviseDoneButton.enabled = true
        addToolBarButton(reviseDoneButton, atIndex: toolBarItems.count)
        //removeToolBarButton(addNoteButton)
        
        //toolBarItems.insert(<#T##newElement: Element##Element#>, atIndex: index)
        mainToolBar.setItems(toolBarItems, animated: true)
        showToolButton.animateShow(0.2)
    }
}
