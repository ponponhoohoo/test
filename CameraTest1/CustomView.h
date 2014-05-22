//
//  CustomView.h
//  ScrollViewPaging
//
//  Created by Hiroshi Hashiguchi on 10/10/06.
//  Copyright 2010 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@class ViewController;
@interface CustomView : UIView {
    NSInteger selectedIndex_;
	UIColor* color;
}
@property(nonatomic, strong) GPUImageStillCamera *stillCamera;
@property(nonatomic, strong) GPUImageFilter *filter;
@property(nonatomic, strong) GPUImageFilterGroup *filterGroup;

@property (nonatomic, strong) ViewController* viewController;
@property (nonatomic, strong) NSMutableArray* imageList;
@end
