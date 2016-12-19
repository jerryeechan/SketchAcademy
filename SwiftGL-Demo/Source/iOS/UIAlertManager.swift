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
    func displayloadView(_ viewController:UIViewController)
    {
        let loadAlertController = UIAlertController(title: "Load Artwork", message: "type in the file name", preferredStyle: UIAlertControllerStyle.alert)
        
        
        var inputTextField: UITextField?
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            let fName = inputTextField?.text
            
            if (fName != nil)
            {
                print("load the file \(fName)", terminator: "")
                //paintManager.loadArtwork(fName!+".paw")
            }
            else
            {
                
            }
        })
        
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        loadAlertController.addTextField{ (textField) -> Void in
            inputTextField = textField
            // Here you can configure the text field (eg: make it secure, add a placeholder, etc)
        }
        
        
        loadAlertController.addAction(ok)
        loadAlertController.addAction(cancel)
        
        viewController.present(loadAlertController, animated: true, completion: nil)
    }
    
    func displayError(_ viewController:UIViewController)
    {
        let saveAlertController = UIAlertController(title: "Save File", message: "type in the file name", preferredStyle: UIAlertControllerStyle.alert)
        
        viewController.present(saveAlertController, animated: true, completion: nil)
    }
}
