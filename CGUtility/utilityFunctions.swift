//
//  utilityFunctions.swift
//  SwiftGL
//
//  Created by jerry on 2016/12/19.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
func scaleImage(image:UIImage,scale:CGFloat)->UIImage{
    //let flipImage =
    let newSize = CGSize(width: Int(image.size.width * scale), height: Int(image.size.height * scale))
    
    UIGraphicsBeginImageContext(newSize)
    
    
    //Fliping the context y-axis
    //let context = UIGraphicsGetCurrentContext();
    //CGContextScaleCTM(context, 1, -1)
    //CGContextTranslateCTM(context, 0, -newSize.height);
    
    image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!;
}
public func + (a: CGPoint, b: CGPoint) -> CGPoint {return CGPoint(x: a.x + b.x, y: a.y + b.y)}
public func += (a: inout CGPoint, b: CGPoint) {a = a + b};

func getViewController(_ identifier:String)->UIViewController
{
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    
}
func uIntColor(_ red:UInt8,green:UInt8,blue:UInt8,alpha:UInt8)->UIColor
{
    return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha)/255)
}
var themeDarkColor = uIntColor(36, green: 53, blue: 62, alpha: 255)
var themeLightColor = uIntColor(244, green: 149, blue: 40, alpha: 255)
func DLog(_ message: String, filename: String = #file, line: Int = #line, function: String = #function){
    #if DEBUG
        print("\((filename as NSString).lastPathComponent):\(line):\(message)")
    #else
        print("not debug")
    #endif
}
