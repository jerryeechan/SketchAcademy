//
//  NoteFile.swift
//  SwiftGL
//
//  Created by jerry on 2015/10/28.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
import PaintStrokeData
public class NoteFile: File {
    
    //file format: example.nt
    //contain with the note tags
    
    override init() {
        
    }

    func save(_ notes:[Note],filename:String)
    {
        data = NSMutableData()
        print(notes, terminator: "")
        print("save: Note count\(notes.count)", terminator: "")
        encodeStruct(notes.count)       //1.note count
        //let notes = NoteManager.instance.getNoteArray()
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
        
        data.write(toFile: path+"/"+filename+".nt", atomically: true)
    }
    override func delete(_ filename: String) {
        super.delete(filename+".nt")
    }
    func load(_ filename:String)->[Int:Note]
    {
        // need to find the correct format first
        
        let path = createPath(filename+".nt")
        currentPtr = 0
        if checkFileExist(path)
        {
            parseData = readFile(filename+".nt") as NSData!
            var notes:[Int:Note] = [Int:Note]()
            
            let length:Int = parseStruct() //1.note count
            for _ in 0 ..< length
            {
                let title = parseString()
                print("title \(title)", terminator: "")
                let description = parseString()
                print("description \(description)", terminator: "")
                
                let valueData:NoteValueData = parseStruct()
                //print("valueData")
                
                var note:Note
                
                //print(valueData.strokeIndex)
                if title == nil
                {
                    note = Note(title: "", description: description!,valueData: valueData)
                }
                else{
                    note = Note(title: title!, description: description!,valueData: valueData)
                }
                
                
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
