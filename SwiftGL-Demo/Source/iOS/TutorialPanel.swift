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
    @IBAction func tutorialNextStepBtnTouched(sender: UIBarButtonItem) {
        if !paintManager.tutorialNextStep()
        {
            tutorialNextStepButton.enabled = false
        }
        tutorialLastStepButton.enabled = true
        setTutorialStepContent()
    }
    @IBAction func tutorialLastStepBtnTouched(sender: UIBarButtonItem) {
        if !paintManager.tutorialLastStep()
        {
            tutorialLastStepButton.enabled = false
        }
        tutorialNextStepButton.enabled = true
        setTutorialStepContent()
        
    }
    func setTutorialStepContent()
    {
        let note = paintManager.tutorialArtwork.currentNote
        tutorialDescriptionTextView.text = note.description
        tutorialTitleLabel.text = note.title
    }
    @IBAction func tutorialPlayPauseTouched(sender: PlayPauseButton) {
    }

    @IBAction func tutorialReplayBtnTouched(sender: UIBarButtonItem) {
    }
}
