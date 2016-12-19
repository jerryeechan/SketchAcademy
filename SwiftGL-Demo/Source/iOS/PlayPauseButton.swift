//
//  PlayPauseButton.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/14.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import UIKit
class PlayPauseButton: UIBarButtonItem{
    let playImage = UIImage(named: "play-arrow")
    let pauseImage = UIImage(named: "pause")
    func playing(_ state:Bool)
    {
        if !state
        {
            image = playImage
        }
        else
        {
            image = pauseImage
        }
    }

}
