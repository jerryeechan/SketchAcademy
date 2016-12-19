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

    override func viewDidAppear(_ animated: Bool) {
        
        if imageView != nil
        {
            imageView.removeFromSuperview()
    
        }
        imageView = SKView(frame: CGRect(x: 0, y: 0, width: 1024, height: 724))
        view.addSubview(imageView)
        
        scene = ReferenceImageScene(size: view.bounds.size)
        let skView = imageView as SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        skView.presentScene(scene)
        
    }
    
    
    @IBAction func toolModeSegControlValueChanged(_ sender: UISegmentedControl) {
        scene.rectToolMode = ReferenceImageScene.RectToolMode(rawValue: sender.selectedSegmentIndex)!
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func toggleButtonTouched(_ sender: UIBarButtonItem) {
        saveRefImage()
    }
    @IBAction func doneButtonTouched(_ sender: UIBarButtonItem) {
        saveRect()
        performSegue(withIdentifier: "showPaintView", sender: self)
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
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
        if imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)==true
        {
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img
        }
        return nil
    }

    @IBAction func refreshButtonTouched(_ sender: UIBarButtonItem) {
        scene.cleanUp()
    }
    
    
}
