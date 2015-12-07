//
//  PaintViewControllerInitStyle.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/5.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

extension PaintViewController
{
    func initAnimateState()
    {
        toolViewState = SubViewPanelAnimateState(view: toolView, constraint: toolViewLeadingConstraint, hideValue: -240, showValue: 0)
        
        noteEditViewState = SubViewPanelAnimateState(view: noteEditView, constraint: noteEditViewTopConstraint, hideValue: -384 , showValue: 0)
        
        noteListViewState = SubViewPanelAnimateState(view: noteListView, constraint: noteListViewTrailingConstraint, hideValue: -240, showValue: 0)
        
        playBackViewState = SubViewPanelAnimateState(view: playBackView, constraint: playBackViewBottomConstraint, hideValue: 128, showValue: 0)
        
        toolViewState.animateHide(0)
        noteListViewState.animateHide(0)
        playBackViewState.animateHide(0)
        noteEditViewState.animateHide(0)
    }

    //Apearance
    func drawNoteEditTextViewStyle()
    {
        
        noteEditTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        noteEditTextView.layer.borderWidth = 1
        noteEditTextView.layer.cornerRadius = 5
        noteEditTextView.clipsToBounds = true
        
    }
}
