//
//  MenuViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/11/16.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
class LearnMenuViewController:UICollectionViewController{
    
    
    
    func createFaceGameViewController()->FaceGameViewController
    {
        return self.storyboard!.instantiateViewController(withIdentifier: "facegame") as! FaceGameViewController
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = createFaceGameViewController()
        switch (indexPath as NSIndexPath).row {
        case 0:
            vc.levelName = FaceGameViewController.FaceGameLevelName.angryBird
        case 1:
            vc.levelName = FaceGameViewController.FaceGameLevelName.greenMan
        case 2:
            vc.levelName = FaceGameViewController.FaceGameLevelName.tumbler
        default:
            vc.levelName = FaceGameViewController.FaceGameLevelName.angryBird
        }
        
         present(vc, animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "\((indexPath as NSIndexPath).row)", for: indexPath)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    
    
    @IBAction func lesson3BtnTouched(_ sender: UIButton) {
        let vc = createFaceGameViewController()
        vc.levelName = FaceGameViewController.FaceGameLevelName.tumbler
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func dismissBtnTouched(_ sender: UIBarButtonItem) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        
    }
}
