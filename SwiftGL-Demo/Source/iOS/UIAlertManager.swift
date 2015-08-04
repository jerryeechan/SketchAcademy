//
//  UIAlertManager.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/7.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import UIKit
class UIAlertManager{
    
    class var instance:UIAlertManager{
        struct Singleton {
            static let instance = UIAlertManager()
        }
        return Singleton.instance
    }
    
    /**
    *  display open file aleart window, input the file name and return if success of loading the file.
    */
    func displayloadView(viewController:UIViewController)
    {
        let loadAlertController = UIAlertController(title: "Load Artwork", message: "type in the file name", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        var inputTextField: UITextField?
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            let fName = inputTextField?.text
            
            if (fName != nil)
            {
                print("load the file \(fName)")
                PaintRecorder.instance.loadArtwork(fName!+".paw")
            }
            else
            {
                
            }
        })
        
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        
        loadAlertController.addTextFieldWithConfigurationHandler{ (textField) -> Void in
            inputTextField = textField
            // Here you can configure the text field (eg: make it secure, add a placeholder, etc)
        }
        
        
        loadAlertController.addAction(ok)
        loadAlertController.addAction(cancel)
        
        viewController.presentViewController(loadAlertController, animated: true, completion: nil)
    }
    
    func displayError(viewController:UIViewController)
    {
        let saveAlertController = UIAlertController(title: "Save File", message: "type in the file name", preferredStyle: UIAlertControllerStyle.Alert)
        
        viewController.presentViewController(saveAlertController, animated: true, completion: nil)
    }
}