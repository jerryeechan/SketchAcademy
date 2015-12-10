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
    private var noteDict:[Int:Note] = [Int:Note]()
    //private var noteList:[Note] = []
    private var id:Int = 0
    var editingNoteIndex:Int = -1
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
        let at = sortedKeys[index]
        return noteDict[at]
    }
    func deleteNoteAtStroke(at:Int)
    {
        noteDict[at] = nil
        sortedKeys = getSortedKeys()
    //    noteList.removeAtIndex(index)
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
    func addNote(at:Int,title:String,description:String)
    {
        noteDict[at] = Note(title: "\(title)", description: description, strokeIndex: at,type: NoteType.Note)
        sortedKeys = getSortedKeys()
        //noteList.sortInPlace({$0.value.strokeIndex < $1.value.strokeIndex})
    }
    func getNotes()->[Int:Note]
    {
        return noteDict
    }
    //var selectedNoteIndex:Int = -1
    
    func getNoteIndexFromStrokeID(strokeID:Int)->Int
    {
        for var i=0; i<sortedKeys.count-1; i++
        {
            if strokeID >= sortedKeys[i] && strokeID < sortedKeys[i+1]
            {
                return i
            }
            
        }
        if strokeID == 0
        {
            return -1
        }
        else if sortedKeys.count == 0
        {return -1}
        else
        {return sortedKeys.count-1}

        
    }

    /*
    func selectNote(at:Int)->Note
    {
        //selectedNoteIndex = index
        return getNote(at)
    }*/
    func getNoteAtStroke(at:Int)->Note
    {
        return noteDict[at]!
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

