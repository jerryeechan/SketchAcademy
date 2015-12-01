
//
//  FaceGameViewController.swift
//  SwiftGL
//
//  Created by CSC NTHU on 2015/8/15.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit
import SpriteKit

class FaceGameViewController: UIViewController {
    
    @IBOutlet weak var faceGameView: UIView!
    enum FaceGameLevelName{
        case AngryBird
        case GreenMan
        case Tumbler
    }
    var scene:FaceGameScene!
    
    var levelName = FaceGameLevelName.GreenMan
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = FaceGameScene(size: view.bounds.size)
        scene.levelName = levelName
        
        let skView = faceGameView as! SKView
        
        skView.presentScene(scene)
        //difficultyLabel.title = "\(1)"
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func confirmButtonTouched(sender: UIButton) {
        //new cal score
        scene.calScore()
    }
    
    @IBAction func newStageButtonTouched(sender: UIButton) {
        //new stage
        scene.newStage()
    }
 
    @IBAction func hintButtonTouchDown(sender: UIButton) {
        scene.showImg()
    }
    
    @IBAction func hintButtonTouchUpInside(sender: UIButton) {
        scene.hideImg()

    }

    @IBAction func hintButtonTouchUpOutside(sender: UIButton) {
        scene.hideImg()

    }
    
    @IBAction func restartButtonTouched(sender: UIButton) {
        scene.restart()
    }
    
    @IBAction func dismissButtonTouched(sender: UIButton) {
          presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}