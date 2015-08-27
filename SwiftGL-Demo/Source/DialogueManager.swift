//
//  DialogueManager.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/20.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation

class DialogueManager {
    class var instance:DialogueManager{
        struct Singleton{
            static let instance = DialogueManager()
        }
        return Singleton.instance
    }
    init()
    {
        
    }
    func PlayDialogue()
    {
        
    }
}