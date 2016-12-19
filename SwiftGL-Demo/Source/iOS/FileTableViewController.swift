//
//  FileTableViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/9.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import UIKit

class FileTableViewController: UITableViewController {
    weak var delegate:PaintViewController!
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) 
        let fName = FileManager.instance.getFileNames()[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = FileManager.instance.loadImg(fName)
        cell.textLabel?.text = fName
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("file counts:\(FileManager.instance.getFileNames().count)", terminator: "")
        
        return FileManager.instance.getFileNames().count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileName = FileManager.instance.getFileNames()[(indexPath as NSIndexPath).row]
        //self.delegate.resetAnchor()
       // paintManager.loadArtwork(fileName)
        //FileManager.instance.loadPaintArtWork(fileName).replayAll()
        delegate.noteListTableView.reloadData()
        
        self.dismiss(animated: true, completion:{
        })
    }
}
