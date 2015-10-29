//
//  OpenCVWrapper.m
//  SwiftGL
//
//  Created by jerry on 2015/9/29.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//



#include "OpenCVWrapper.h"
#import "UIImage+OpenCV.h"



using namespace cv;
using namespace std;

@implementation OpenCVWrapper : NSObject

+ (float)calculateImgSimilarity:(UIImage*)UIImg1 secondImg:(UIImage*)UIImg2 {
    
    
    Mat img_1 = UIImg1.CVMat;
    Mat img_2 = UIImg2.CVMat;
    
    //-- Step 1: Detect the keypoints using SURF Detector
    
    Ptr<KAZE> detector = KAZE::create();
    
    printf("%d\n",detector->empty());
    
    std::vector<KeyPoint> keypoints_1, keypoints_2;
    
    detector->detect(img_1, keypoints_1);
    detector->detect(img_2, keypoints_2);
    
    
    //-- Step 2: Calculate descriptors (feature vectors)
    
    Mat descriptors_1, descriptors_2;
    
    detector->compute( img_1, keypoints_1, descriptors_1 );
    detector->compute( img_2, keypoints_2, descriptors_2 );
    
      //-- Step 3: Matching descriptor vectors using FLANN matcher
    
    Ptr<BFMatcher> matcher = new BFMatcher();
    std::vector< DMatch > matches;
    matcher->match( descriptors_1, descriptors_2, matches );
    
    
    double max_dist = 0; double min_dist = 100;
    
    //-- Quick calculation of max and min distances between keypoints
    double error = 0;
    for( int i = 0; i < matches.size(); i++ )
    {
        double dist = matches[i].distance;
        error += dist;
        if( dist < min_dist ) min_dist = dist;
        if( dist > max_dist ) max_dist = dist;
    }
    
    printf("error %f\n",error);
    printf("-- Max dist : %f \n", max_dist );
    printf("-- Min dist : %f \n", min_dist );

    
    // do your processing here
    
    //[UIImage imageWithCVMat:mat1]
    return 0;
}

@end