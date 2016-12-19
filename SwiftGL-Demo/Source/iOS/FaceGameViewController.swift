
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
        case angryBird
        case greenMan
        case tumbler
    }
    var scene:FaceGameScene!
    
    var levelName = FaceGameLevelName.greenMan
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = FaceGameScene(size: view.bounds.size)
        scene.levelName = levelName
        
        let skView = faceGameView as! SKView
        
        skView.presentScene(scene)
        //difficultyLabel.title = "\(1)"
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func confirmButtonTouched(_ sender: UIButton) {
        //new cal score
        scene.calScore()
    }
    
    @IBAction func newStageButtonTouched(_ sender: UIButton) {
        //new stage
        scene.newStage()
    }
 
    @IBAction func hintButtonTouchDown(_ sender: UIButton) {
        scene.showImg()
    }
    
    @IBAction func hintButtonTouchUpInside(_ sender: UIButton) {
        scene.hideImg()

    }

    @IBAction func hintButtonTouchUpOutside(_ sender: UIButton) {
        scene.hideImg()

    }
    
    @IBAction func restartButtonTouched(_ sender: UIButton) {
        scene.restart()
    }
    
    @IBAction func dismissButtonTouched(_ sender: UIButton) {
          presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
