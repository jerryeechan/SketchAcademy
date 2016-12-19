//
//  TutorialPanel.swift
//  SwiftGL
//
//  Created by jerry on 2016/5/2.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

extension PaintViewController
 {
    //tutorail replay
    @IBAction func tutorialNextStepBtnTouched(_ sender: UIBarButtonItem) {
        
        if !paintManager.tutorialNextStep()
        {
            tutorialNextStepButton.isEnabled = false
        }
        tutorialLastStepButton.isEnabled = true
        setTutorialStepContent()
    }
    @IBAction func tutorialLastStepBtnTouched(_ sender: UIBarButtonItem) {
        
        if !paintManager.tutorialLastStep()
        {
            tutorialLastStepButton.isEnabled = false
        }
        tutorialNextStepButton.isEnabled = true
        setTutorialStepContent()
        
    }
    func setTutorialStepContent()
    {
        let note = paintManager.tutorialArtwork.currentNote
        if((note) != nil)
        {
            tutorialDescriptionTextView.text = note?.description
            tutorialTitleLabel.text = note?.title
        }
        
    }
    @IBAction func tutorialPlayPauseTouched(_ sender: PlayPauseButton) {
        paintManager.tutorialToggle()
    }

    @IBAction func tutorialReplayBtnTouched(_ sender: UIBarButtonItem) {
    }
}
