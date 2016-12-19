//
//  LessonDescriptionViewController.swift
//  SwiftGL
//
//  Created by jerry on 2016/4/28.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import UIKit
class LessonDescriptionViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var pageControl: UIPageControl!

    let totalPages = 5

    override func viewDidLoad() {
        //configureScrollView()
        //configurePageControl()
    }
    
    func configureScrollView() {
        // Enable paging.
        
    }
    
    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        
    }
    
    func configurePageControl() {
        // Set the total pages to the page control.
        pageControl.numberOfPages = totalPages
        
        // Set the initial page.
        pageControl.currentPage = 0
    }
}
