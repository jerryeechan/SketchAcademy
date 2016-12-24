//
//  LessonMenuDetailViewController.swift
//  SwiftGL
//
//  Created by jerry on 2016/4/29.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import UIKit
import GLFramework
class LessonMenuDetailViewController: UIViewController {
    
    var lessonData:LessonData!{
        didSet{
            updateUI(lessonData)
        }
    }
    
    func updateUI(_ data:LessonData)
    {
        lessonNumber.text = "Lesson \(data.lessonOrder)"
        lessonTitle.text = data.title
        goalText.text = data.goal
    }
    
    @IBOutlet weak var lessonNumber: UILabel!
    
    @IBOutlet weak var lessonTitle: UILabel!
    
    @IBOutlet weak var goalText: UITextView!
    
    @IBAction func startButtonTouched(_ sender: UIButton) {
        PaintViewController.courseTitle = "upsidedown"
        PaintViewController.appMode = ApplicationMode.instructionTutorial
        //let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let rootViewController = appdelegate.window?.rootViewController
        
        let paintViewController = getViewController("paintview") as! PaintViewController
        
        present(paintViewController, animated: true, completion: nil)
    }
    
}
