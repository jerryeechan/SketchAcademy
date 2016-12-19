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
        
        //noteEditViewState = SubViewPanelAnimateState(view: noteEditView, constraint: noteEditViewTopConstraint, hideValue: -384 , showValue: 0)
        
        noteListViewState = SubViewPanelAnimateState(view: noteListView, constraint: noteListViewTrailingConstraint, hideValue: -240, showValue: 0)
        
        
        toolViewState.animateHide(0.2)
        noteListViewState.animateHide(0)
        
        //noteEditViewState.animateHide(0)
        
        noteListTableView.separatorStyle = .none
        //drawGreyBorder(noteListTableView)
        //drawGreyBorder(toolView)
        
        circleButton(showToolButton)
        
    }

    //Apearance
    func drawNoteEditTextViewStyle()
    {
        
        noteEditTextView.layer.borderColor = UIColor.lightGray.cgColor
        noteEditTextView.layer.borderWidth = 1
        noteEditTextView.layer.cornerRadius = 5
        noteEditTextView.clipsToBounds = true
        
        
    }
    
    func drawGreyBorder(_ view:UIView)
    {
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        
        //view.layer.cornerRadius =
        
    }
    
    func circleButton(_ button:UIButton)
    {
        button.layer.cornerRadius = 0.5 * button.frame.width
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        //var tintedImage = button.imageForState(UIControlState.Normal)
        
        //tintedImage = button. [self tintedImageWithColor:color image:tintedImage];
        //[self setImage:tintedImage forState:state];
    }
    
}
