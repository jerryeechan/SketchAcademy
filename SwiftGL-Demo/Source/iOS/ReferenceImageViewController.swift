//
//  ReferenceImageViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/14.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import UIKit
import SpriteKit

class ReferenceImageViewController: UIViewController {
    
    //@IBOutlet
    var imageView: SKView!
    
    var scene:ReferenceImageScene!

    override func viewDidAppear(animated: Bool) {
        
        if imageView != nil
        {
            imageView.removeFromSuperview()
    
        }
        imageView = SKView(frame: CGRectMake(0, 0, 1024, 724))
        view.addSubview(imageView)
        
        scene = ReferenceImageScene(size: view.bounds.size)
        let skView = imageView as SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        skView.presentScene(scene)
        
    }
    
    
    @IBAction func toolModeSegControlValueChanged(sender: UISegmentedControl) {
        scene.rectToolMode = ReferenceImageScene.RectToolMode(rawValue: sender.selectedSegmentIndex)!
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func toggleButtonTouched(sender: UIBarButtonItem) {
        saveRefImage()
    }
    @IBAction func doneButtonTouched(sender: UIBarButtonItem) {
        saveRect()
        performSegueWithIdentifier("showPaintView", sender: self)
    }
    func saveRect()
    {
        RefImgManager.instance.rectImg = getImage()
    }
    func saveRefImage()
    {
        RefImgManager.instance.refImg = getImage()
        scene.removeRefImg()
        
    }
    func getImage()->UIImage!
    {
        //UIGraphicsBeginImageContext(imageView.bounds.size)
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.mainScreen().scale)
        if imageView.drawViewHierarchyInRect(imageView.bounds, afterScreenUpdates: true)==true
        {
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img
        }
        return nil
    }

    @IBAction func refreshButtonTouched(sender: UIBarButtonItem) {
        scene.cleanUp()
    }
    
    
}
