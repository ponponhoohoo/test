//
//  ViewController.h
//  CameraTest1
//
//  Created by Takashi Ohtsuka on 2013/05/22.
//  Copyright (c) 2013年 takatronix.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyScrollView.h"
#import "StampView.h"
#import "GestureImageView.h"
@class ThumbnailView;

@interface ViewController : UIViewController <StampViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    BOOL sepia_flg;
    BOOL gray_flg;
    BOOL bright_flg;
}
@property (nonatomic, retain) IBOutlet UISlider *sl;
@property (nonatomic, strong) IBOutlet UISwitch *brigthsw;
@property (nonatomic, retain) IBOutlet UILabel *lb;
- (IBAction)SliderChanged:(id)sender;
@property(nonatomic, strong) UIView * StampDisplayView;
@property(nonatomic, strong) UIImage* Original;
@property(nonatomic, strong) UIImageView* ThumView;
@property(nonatomic, strong) GestureImageView* MainImage;
@property(nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet ThumbnailView *thumnailView;
- (IBAction)pressBtn:(id)sender;
@property (nonatomic, strong)  UIScrollView *ImagePanel;
@property (nonatomic, weak)  IBOutlet UIView *stampPanel;
@property (nonatomic, weak)  IBOutlet UIView *stampPanelClose;
@property (nonatomic, weak)  IBOutlet UIButton *stampThumb1;
@end
