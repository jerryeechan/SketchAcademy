//
//  MenuViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/2.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//
import UIKit
class MenuViewController: UIViewController{
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        */
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //self.navigationController?.navigationBar.tintColor = .themeColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        /*
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
        */
    }
}
