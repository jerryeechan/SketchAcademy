//
//  ArtworkCollectionViewCell.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/3.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit

class ArtworkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    

    @IBOutlet weak var titleField: UITextField!
    
    
    @IBAction func titleTouched(_ sender: UIButton) {
        
    }
    
    
    @IBOutlet weak var actionButton: UIButton!
    override func awakeFromNib() {
        
    }
    
}
