//
//  OpenViewController.h
//  CameraTest1
//
//  Created by 浜野 剛士 on 2014/01/18.
//  Copyright (c) 2014年 takatronix.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
}
- (IBAction)openCamera:(id)sender;
- (IBAction)openPhotoLibrary:(id)sender;
@end
