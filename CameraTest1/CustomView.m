//
//  CustomView.m
//  ScrollViewPaging
//
//  Created by Hiroshi Hashiguchi on 10/10/06.
//  Copyright 2010 . All rights reserved.
//

#import "CustomView.h"
#import "ViewController.h"


@implementation CustomView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	
	CGRect rect1 = CGRectMake(0, 0, 60, 60);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[color set];
	CGContextFillRect(context, rect1);
	[[UIColor whiteColor] set];
	CGContextSetLineWidth(context, 5);
	CGContextStrokeRect(context, rect1);
}

@end
