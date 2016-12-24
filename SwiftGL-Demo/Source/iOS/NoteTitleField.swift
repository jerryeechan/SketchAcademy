//
//  NoteTitleField.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/13.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import UIKit
public class NoteTitleField:UITextField,UITextFieldDelegate,UIGestureRecognizerDelegate{
    var editTapRecognizer:UITapGestureRecognizer!
    var editable = false
    
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
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
