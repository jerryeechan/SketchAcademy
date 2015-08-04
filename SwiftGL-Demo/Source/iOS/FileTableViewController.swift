//
//  FileTableViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/9.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import UIKit

class FileTableViewController: UITableViewController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FileCell", forIndexPath: indexPath) 
        let fName = FileManager.instance.fileNames[indexPath.row]
        
        cell.imageView?.image = FileManager.instance.loadImg(fName)
        cell.textLabel?.text = fName
        
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("file counts:\(FileManager.instance.fileNames.count)")
        
        return FileManager.instance.fileNames.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let fileName = FileManager.instance.fileNames[indexPath.row]
        
        PaintRecorder.instance.loadArtwork(fileName)
        //FileManager.instance.loadPaintArtWork(fileName).replayAll()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
