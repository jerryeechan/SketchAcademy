//
//  ReviseManager.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/25.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation

class NoteManager {
    class var instance:NoteManager{
        struct Singleton{
            static let instance = NoteManager()
        }
        return Singleton.instance
    }
    
    var noteList:[Note] = []
    func addNote(title:String,description:String)
    {
        noteList.append(Note(title: title, description: description, timestamp: PaintRecorder.instance.artwork.currentTime))
    }
    
    func saveNotes()
    {
        //FileManager.instance.sa
    }
}