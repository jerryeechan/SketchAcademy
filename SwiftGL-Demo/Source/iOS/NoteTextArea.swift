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
        textColor = UIColor.lightGray
        delegate = self
        emptyFlag = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
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
            textColor = UIColor.black
        }
        return true
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        if(self.text == placeholderText)
        {
            if(selectedRange.location != 0)
            {
                selectedRange = NSMakeRange(0, 0)
            }
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(text == placeholderText)
        {
            selectedRange = NSMakeRange(0, 0)
            //text = ""
            //textColor = UIColor.blackColor()
        }
    }
    var emptyFlag = true
    
    func textViewDidChange(_ textView: UITextView) {
        
        if(text == "")
        {
            clear()
        }
        else if emptyFlag == true
        {
            text = text.replacingOccurrences(of: placeholderText, with: "")
            textColor = UIColor.black
            emptyFlag = false
        }
        
    }
    func changeText(_ text:String)
    {
        if(text == "" || text == placeholderText)
        {
            clear()
        }
        else
        {
            self.text = text
            textColor = UIColor.black
            emptyFlag = false
        }

    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer && (gestureRecognizer as! UITapGestureRecognizer).numberOfTapsRequired == 2
        {
            if gestureRecognizer == editTapRecognizer && isEditable == false
            {
                return true
            }
            return false
            
        }
        return true
    }
}
