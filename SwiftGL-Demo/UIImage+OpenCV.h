//
//  UIImage+OpenCV.h
//  SwiftGL
//
//  Created by jerry on 2015/9/29.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

@interface UIImage (OpenCV)
//cv::Mat to UIImage
+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat;
- (id)initWithCVMat:(const cv::Mat&)cvMat;

//UIImage to cv::Mat
- (cv::Mat)CVMat;
- (cv::Mat)CVMat3;  // no alpha channel
- (cv::Mat)CVGrayscaleMat;
@end
