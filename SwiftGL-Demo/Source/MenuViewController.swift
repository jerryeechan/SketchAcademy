//
//  MenuViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/2.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//
import UIKit
class MenuViewController: UIViewController{
    
    override func viewDidAppear(animated: Bool) {
        /*
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        */
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.tintColor = .themeColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewWillDisappear(animated: Bool) {
        /*
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
        */
    }
}
