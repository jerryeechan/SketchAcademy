//
//  DotGameViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/14.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import UIKit
import SpriteKit

class DotGameViewController: UIViewController {
    
    @IBOutlet weak var dotGameView: UIView!
    
    var scene:DotGameScene!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = DotGameScene(size: view.bounds.size)
        let skView = dotGameView as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        skView.presentScene(scene)
        difficultyLabel.title = "\(1)"
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
    
    
    @IBOutlet weak var difficultyLabel: UIBarButtonItem!
    
    @IBAction func difficultyStepperValueChanged(sender: UIStepper) {
        let v = Int(sender.value)
        difficultyLabel.title = String(v)
        scene.changeDifficulty(v)
    }
    
    @IBAction func restartButtonTouched(sender: UIButton) {
        scene.restart()
    }
    
    func newStage()
    {
        scene.newStage()
    }
    
   
}