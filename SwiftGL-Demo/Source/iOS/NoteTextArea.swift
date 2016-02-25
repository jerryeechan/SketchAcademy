//
//  NoteTextArea.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/13.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import UIKit
class NoteTextArea: UITextView ,UITextViewDelegate,UIGestureRecognizerDelegate{
    var editTapRecognizer:UITapGestureRecognizer!
    var placeholderText = "輸入註解描述..."
    func clear()
    {
        text = placeholderText
        textColor = UIColor.lightGrayColor()
        delegate = self
        emptyFlag = true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if(text.characters.count == 0)
        {
            if range.location == 0 && textView.text.characters.count == 1
            {
               clear()
            }
        }
        else if(textView.text == placeholderText)
        {
            self.text = ""
            textColor = UIColor.blackColor()
        }
        return true
    }
    func textViewDidChangeSelection(textView: UITextView) {
        if(self.text == placeholderText)
        {
            if(selectedRange.location != 0)
            {
                selectedRange = NSMakeRange(0, 0)
            }
        }
    }
    func textViewDidBeginEditing(textView: UITextView) {
        
        if(text == placeholderText)
        {
            selectedRange = NSMakeRange(0, 0)
            //text = ""
            //textColor = UIColor.blackColor()
        }
    }
    var emptyFlag = true
    
    func textViewDidChange(textView: UITextView) {
        
        if(text == "")
        {
            clear()
        }
        else if emptyFlag == true
        {
            text = text.stringByReplacingOccurrencesOfString(placeholderText, withString: "")
            textColor = UIColor.blackColor()
            emptyFlag = false
        }
    }
    
    
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer && (gestureRecognizer as! UITapGestureRecognizer).numberOfTapsRequired == 2
        {
            if gestureRecognizer == editTapRecognizer && editable == false
            {
                return true
            }
            return false
            
        }
        return true
    }
}
