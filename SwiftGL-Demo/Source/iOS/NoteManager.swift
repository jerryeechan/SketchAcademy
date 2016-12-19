//
//  ReviseManager.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/25.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
import PaintStrokeData
class NoteManager {
    class var instance:NoteManager{
        struct Singleton{
            static let instance = NoteManager()
        }
        return Singleton.instance
    }
    var noteButtonDict:[Int:NoteButton] = [Int:NoteButton]()
    var selectedButtonIndex:Int!
    fileprivate var noteDict:[Int:Note] = [Int:Note]()
    func getNoteButton(_ atStroke:Int)->NoteButton!
    {
        return noteButtonDict[atStroke]
    }
    func addNoteButton(_ noteButton:NoteButton,note:Note)
    {
        noteButton.note = note
        noteButtonDict[note.value.strokeIndex] = noteButton
        DLog("\(note.value.strokeIndex)")
    }
    
    //private var noteList:[Note] = []
    var editingNoteIndex:Int = -1
    func empty()
    {
        noteDict = [Int:Note]()
        editingNoteIndex = -1
    }
    func loadNotes(_ filename:String)
    {
        noteDict = FileManager.instance.loadNotes(filename)
        getSortedKeys()
    }
    /*
    func getNotes()->[Note]
    {
        return [Int](noteDict.keys)
    }*/
    func removeAllButton()
    {
        for button in noteButtonDict.values
        {
            button.removeFromSuperview()
        }
    }
    func getNoteArray()->[Note]
    {
        let sortedArray = Array(noteDict.values).sorted(by: {$0.value.strokeIndex < $1.value.strokeIndex})
        return sortedArray
    }
    func getSortedKeys()->[Int]
    {
        sortedKeys = Array(noteDict.keys).sorted()        
        return sortedKeys
    }
    var sortedKeys:[Int] = []
    func getOrderedNote(_ index:Int)->Note!
    {
        getSortedKeys()
        if index < sortedKeys.count
        {
            let at = sortedKeys[index]
            return noteDict[at]
        }
        else
        {
            return nil
        }
    }
    func deleteNoteAtStroke(_ at:Int)->Int
    {
        selectedButtonIndex = nil
        let noteButton = getNoteButton(at)
        noteButtonDict[at] = nil
        noteButton?.removeFromSuperview()
        noteDict.removeValue(forKey: at)
        sortedKeys = getSortedKeys()
        return sortedKeys.count
    }
    func updateOrderedNote(_ index:Int,title:String,description:String)
    {
        updateNote(sortedKeys[index], title: title, description: description)
    }
    func updateNote(_ at:Int,title:String,description:String)
    {
        noteDict[at]?.title = title
        noteDict[at]?.description = description
        noteDict[at]?.value.strokeIndex = at
        
        /*
        if editingNoteIndex < 0
        {
            print("edit note did not set")
            return
        }
        noteList[editingNoteIndex].title = title
        noteList[editingNoteIndex].description = description
        editingNoteIndex = -1
*/
    }
    func addNote(_ at:Int,title:String,description:String)->Note
    {
        noteDict[at] = Note(title: "\(title)", description: description, strokeIndex: at,type: NoteType.note)
        sortedKeys = getSortedKeys()
        return noteDict[at]!
        //noteList.sortInPlace({$0.value.strokeIndex < $1.value.strokeIndex})
    }
    func getNotes()->[Int:Note]
    {
        return noteDict
    }
    //var selectedNoteIndex:Int = -1
    
    //the array index of the floor strokeID
    func getFloorNoteIndexFromStrokeID(_ strokeID:Int)->Int
    {
        getSortedKeys()
        DLog("\(sortedKeys)")
        for i in 0 ..< sortedKeys.count
        {
            if strokeID < sortedKeys[i]
            {
                if i==0
                {
                    return -1
                }
                else
                {
                    return i-1
                }
                
            }
        }
        return sortedKeys.count-1
        /*
        if strokeID == 0
        {
            return -1
        }
        else if sortedKeys.count == 0
        {return -1}
        else
        {return sortedKeys.count-1}
        */
        
    }

    /*
    func selectNote(at:Int)->Note
    {
        //selectedNoteIndex = index
        return getNote(at)
    }*/
    func getNoteAtStroke(_ at:Int)->Note!
    {
        return noteDict[at]
    }
    var noteCount:Int
    {
        get
        {
            return noteDict.count
        }
    }
    func saveNotes()
    {
        FileManager.instance
    }
    
}

