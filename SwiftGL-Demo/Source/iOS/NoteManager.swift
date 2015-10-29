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
    
    private var noteList:[Note] = []
    private var id:Int = 0
    var editingNoteIndex:Int = -1
    func loadNotes(filename:String)
    {
        noteList = FileManager.instance.loadNoteList(filename)
    }
    func getNotes()->[Note]
    {
        return noteList
    }
    func deleteNote(index:Int)
    {
        noteList.removeAtIndex(index)
    }
    func editNote(title:String,description:String)
    {
        if editingNoteIndex < 0
        {
            print("edit note did not set")
            return
        }
        noteList[editingNoteIndex].title = title
        noteList[editingNoteIndex].description = description
        editingNoteIndex = -1
    }
    func addNote(title:String,description:String)
    {
        noteList.append(Note(title: "\(title)", description: description, strokeIndex: PaintReplayer.instance.currentStrokeID))
        print("add note stroke id:\(PaintReplayer.instance.currentStrokeID)")
        
        noteList.sortInPlace({$0.value.strokeIndex < $1.value.strokeIndex})
    }
    var selectedNoteIndex:Int = -1
    func getNoteIndexFromStrokeID(strokeID:Int)->Int
    {
        for var i=0; i<noteList.count-1; i++
        {

            if strokeID >= noteList[i].value.strokeIndex && strokeID < noteList[i+1].value.strokeIndex
            {
                return i;
            }
        }
        if strokeID == 0
        {
            return -1
        }
        else if noteList.count == 0
        {return -1}
        else
        {return noteList.count-1}
    }
    func selectNote(index:Int)->Note
    {
        selectedNoteIndex = index
        return getNote(index)
    }
    func getNote(index:Int)->Note
    {
        return noteList[index]
    }
    func noteCount()->Int
    {
        return noteList.count
    }
    func saveNotes()
    {
        FileManager.instance
    }
}

