//
//  SoundGenerator.swift
//  SwiftGL
//
//  Created by jerry on 2017/1/8.
//  Copyright © 2017年 Jerry Chan. All rights reserved.
//


import Foundation
import AudioKit
public class SoundGenerator{
    public init()
    {
        oscillator = AKOscillator()
        AudioKit.output = oscillator
        AudioKit.start()
        /*
        do{
            let pencil = try AKAudioFile(readFileName: "pencil.aiff")
            try audioPlayer = AKAudioPlayer(file: pencil, looping: true, completionHandler: nil)
        }
        catch
        {
            
        }*/
        //audioPlayer.play()
    }
    
    
    var oscillator:AKOscillator
    public func start()
    {    
        oscillator.start()
    }
    public func play(point:PaintPoint)
    {
        oscillator.amplitude = Double(point.force)// random(0.5, 1)
        let v = Int(point.velocity.length*20)/20
        oscillator.frequency = Double(v)*20 + 360.0// random(220, 880)
        //oscillator.start()
    }
    public func stop()
    {
        oscillator.stop()
    }
    deinit {
        AudioKit.stop()
    }
    
    var audioPlayer:AKAudioPlayer!
    public func playSOund(){
        
        
    }
    
    func playBlaster() {
       
    }
}
