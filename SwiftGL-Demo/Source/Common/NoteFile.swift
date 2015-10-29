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

    func save(notes:[Note],filename:String)
    {
        let data = NSMutableData()
        
        encodeStruct(notes.count)
        for note in notes
        {
            encodeString(note.title)
            encodeString(note.description)
            data.appendBytes([note.value],length: sizeof(NoteValueData))

        }
        
        let path = File.dirpath
        
        data.writeToFile(path+"/"+filename+".nt", atomically: true)
    }
    func load(filename:String)->[Note]
    {
        let path = createPath(filename)
        currentPtr = 0
        if checkFileExist(path)
        {
            data = readFile(filename) as! NSMutableData
            var notes:[Note] = []
            
            let length:Int = parseStruct()
            for _ in 0...length
            {
                let note = Note(title: parseString(), description: parseString(),valueData: parseStruct())
                notes.append(note)
            }
            return notes
        }
        else
        {
            return []
        }

    }
}