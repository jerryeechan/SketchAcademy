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
    var noteButtonDict:[Int:NoteButton] = [Int:NoteButton]()
    var selectedButtonIndex:Int!
    private var noteDict:[Int:Note] = [Int:Note]()
    func getNoteButton(atStroke:Int)->NoteButton!
    {
        return noteButtonDict[atStroke]
    }
    func addNoteButton(noteButton:NoteButton,note:Note)
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
    func loadNotes(filename:String)
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
        let sortedArray = Array(noteDict.values).sort({$0.value.strokeIndex < $1.value.strokeIndex})
        return sortedArray
    }
    func getSortedKeys()->[Int]
    {
        sortedKeys = Array(noteDict.keys).sort()        
        return sortedKeys
    }
    var sortedKeys:[Int] = []
    func getOrderedNote(index:Int)->Note!
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
    func deleteNoteAtStroke(at:Int)->Int
    {
        selectedButtonIndex = nil
        let noteButton = getNoteButton(at)
        noteButtonDict[at] = nil
        noteButton.removeFromSuperview()
        noteDict.removeValueForKey(at)
        sortedKeys = getSortedKeys()
        return sortedKeys.count
    }
    func updateOrderedNote(index:Int,title:String,description:String)
    {
        updateNote(sortedKeys[index], title: title, description: description)
    }
    func updateNote(at:Int,title:String,description:String)
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
    func addNote(at:Int,title:String,description:String)->Note
    {
        noteDict[at] = Note(title: "\(title)", description: description, strokeIndex: at,type: NoteType.Note)
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
    func getFloorNoteIndexFromStrokeID(strokeID:Int)->Int
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
    func getNoteAtStroke(at:Int)->Note!
    {
        return noteDict[at]
    }
    func noteCount()->Int
    {
        return noteDict.count
    }
    func saveNotes()
    {
        FileManager.instance
    }
    
}

