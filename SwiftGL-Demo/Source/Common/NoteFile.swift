//
//  NoteFile.swift
//  SwiftGL
//
//  Created by jerry on 2015/10/28.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
class NoteFile: File {
    
    //file format: example.nt
    //contain with the note tags
    
    override init() {
        
    }

    func save(notes:[Int:Note],filename:String)
    {
        data = NSMutableData()
        print(notes)
        print(notes.count)
        encodeStruct(notes.count)
        if(notes.count>0)
        {
            
            for (_,note) in notes
            {
                encodeString(note.title)
                encodeString(note.description)
                encodeStruct(note.value)
            }
        }
        
        let path = File.dirpath
        
        data.writeToFile(path+"/"+filename+".nt", atomically: true)
    }
    func load(filename:String)->[Int:Note]
    {
        // need to find the correct format first
        
        let path = createPath(filename+".nt")
        currentPtr = 0
        if checkFileExist(path)
        {
            parseData = readFile(filename+".nt")
            var notes:[Int:Note] = [Int:Note]()
            
            let length:Int = parseStruct()
            for var i = 0; i < length; ++i
            {
                let note = Note(title: parseString(), description: parseString(),valueData: parseStruct())
                notes[note.value.strokeIndex] = note
            }
            
            
            return notes
        }
        else
        {
            return [Int:Note]()
        }
        
    }
}