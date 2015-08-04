//
//  AlertViewManager.swift
//  SwiftGL
//
//  Created by jerry on 2015/6/5.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

func displayAlert(uiVController:UIViewController)
{
    
    var alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
    uiVController.presentViewController(alert, animated: true, completion: nil)
    
    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
        switch action.style{
        case .Default:
            
            
        case .Cancel:
            
            
        case .Destructive:
            println("destructive")
        }
    }))
}