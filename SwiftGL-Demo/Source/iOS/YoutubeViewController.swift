//
//  ViewController.swift
//  YouTubePlayerExample
//
//  Created by Giles Van Gruisen on 1/31/15.
//  Copyright (c) 2015 Giles Van Gruisen. All rights reserved.
//

import UIKit
import SwiftYoutubePlayer
import YouTubeiOSPlayerHelper

class YoubuteViewController: UIViewController,YTPlayerViewDelegate  {

    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        
        print(state)
    }
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        print(quality)
    }
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        print(playTime)
    }
    
    @IBAction func play(_ sender: UIButton) {
        /*
        if playerView.ready {
            if playerView.playerState != YouTubePlayerState.Playing {
                playerView.play()
                playButton.setTitle("Pause", for: UIControlState())
            } else {
                playerView.pause()
                playButton.setTitle("Play", for: UIControlState())
            }
        }*/
    }

    @IBAction func prev(_ sender: UIButton) {
        playerView.previousVideo()
    }

    @IBAction func next(_ sender: UIButton) {
        playerView.nextVideo()
        
    }
    
    let playbackSpeeds:[Float] = [0.25,0.5,1]
    @IBAction func changeSpeed()
    {
        //print(playerView.getAvailablePlaybackRates())
        //playerView.setPlaybackRate(suggestedRate: 0.25);
        playerView.setPlaybackRate(0.25)
    }

    @IBAction func loadVideo(_ sender: UIButton) {
        let vars = [
            "enablejsapi": "1" as AnyObject,
             "playsinline": "1" as AnyObject,
            "controls": "1" as AnyObject,
            "showinfo": "1" as AnyObject
        ]
        playerView.load(withVideoId: "bHQqvYy5KYo", playerVars: vars)
        //playerView.playerVars = vars
        
        
        //playerView.loadVideoID()
        //playerView.loadVideoID("4DVf8CtoQSY")
    }

    @IBAction func loadPlaylist(_ sender: UIButton) {
        //playerView.loadPlaylistID("RDe-ORhEE9VVg")
    }

    func showAlert(_ message: String) {
        self.present(alertWithMessage(message), animated: true, completion: nil)
    }

    func alertWithMessage(_ message: String) -> UIAlertController {
        let alertController =  UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        return alertController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

