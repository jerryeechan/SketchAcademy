//
//  MenuViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/11/16.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
class LearnMenuViewController:UIViewController{
    
    
    
    func createFaceGameViewController()->FaceGameViewController
    {
        return self.storyboard!.instantiateViewControllerWithIdentifier("facegame") as! FaceGameViewController
        
    }
    
    
    @IBAction func lesson1btnTouched(sender: UIButton) {
        
        let vc = createFaceGameViewController()
        vc.levelName = FaceGameViewController.FaceGameLevelName.AngryBird
        
        presentViewController(vc, animated: true, completion: nil)

    }
    
    @IBAction func lesson2btnTouched(sender: UIButton) {
        let vc = createFaceGameViewController()
        vc.levelName = FaceGameViewController.FaceGameLevelName.GreenMan
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func lesson3BtnTouched(sender: UIButton) {
        let vc = createFaceGameViewController()
        vc.levelName = FaceGameViewController.FaceGameLevelName.Tumbler
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func dismissBtnTouched(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        
    }
}