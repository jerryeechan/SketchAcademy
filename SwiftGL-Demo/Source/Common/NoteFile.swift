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
        print(notes, terminator: "")
        print("save: Note count\(notes.count)", terminator: "")
        encodeStruct(notes.count)       //1.note count
        let notes = NoteManager.instance.getNoteArray()
        if(notes.count>0)
        {
            for note in notes
            {
                //print("save: note:\(at) \(note.title)")
                encodeString(note.title)
                encodeString(note.description)
                encodeStruct(note.value)
            }
        }
        
        let path = File.dirpath
        
        data.writeToFile(path+"/"+filename+".nt", atomically: true)
    }
    override func delete(filename: String) {
        super.delete(filename+".nt")
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
            
            let length:Int = parseStruct() //1.note count
            for i in 0 ..< length
            {
                let title = parseString()
                print("title \(title)", terminator: "")
                let description = parseString()
                print("description \(description)", terminator: "")
                
                let valueData:NoteValueData = parseStruct()
                //print("valueData")
                
                
                //print(valueData.strokeIndex)
                let note = Note(title: title, description: description,valueData: valueData)
                
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