//
//  MyScrollView.m
//  CameraTest1
//
//  Created by 浜野 剛士 on 2014/01/16.
//  Copyright (c) 2014年 takatronix.com. All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// タッチ終了(タッチから外れた)イベント
// touchesBegan をオーバーライドしておかないと、これは動かない
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesEnded: touches withEvent:event];
    }
    [super touchesEnded: touches withEvent: event];
}

// タッチ開始イベント
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}

@end
