//
//  OpenViewController.m
//  CameraTest1
//
//  Created by 浜野 剛士 on 2014/01/18.
//  Copyright (c) 2014年 takatronix.com. All rights reserved.
//

#import "OpenViewController.h"
#import <CoreImage/CoreImage.h>
#import "ViewController.h"

@interface OpenViewController ()

@end

@implementation OpenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
}
//     カメラを開く
- (IBAction)openCamera:(id)sender {
    
    
    //      カメラが使えるかチェック
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
        //      UIImagePickerControllerを作成し初期化 new = alloc + init
		UIImagePickerController* imagePicker = [UIImagePickerController new];
        //  カメラを開く場合 sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //  編集可能にする場合はYES
        imagePicker.allowsEditing = YES;
        //  自分への通知設定
        imagePicker.delegate = self;
        
        //      フォトライブラリを開く
        [self presentViewController:imagePicker animated:YES
                         completion:^{
                             //     開いたタイミングに呼ばれる
                             NSLog(@"(1)カメラを開いた");
                         }];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//       オリジナル画像
	UIImage* originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
	//       編集画像
	UIImage* editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImage* savedImage;
    if(editedImage){
        savedImage = editedImage;
    }
    else{
        savedImage = originalImage;
    }
    
    //      開いているカメラ・フォトライブラリを閉じる
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    ViewController *viewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoView"];
    viewController.Original = editedImage;
    [self.navigationController pushViewController:viewController animated:YES];
}

//      フォトライブラリを開く
- (IBAction)openPhotoLibrary:(id)sender {
    
    //      フォトライブラリが使えるかチェック
    //      カメラを開く場合
    //      UIImagePickerControllerSourceTypePhotoLibrary　を
    //      UIImagePickerControllerSourceTypeCamera     に変更
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
        //      UIImagePickerControllerを作成し初期化 new = alloc + init
		UIImagePickerController* imagePicker = [UIImagePickerController new];
        //  カメラを開く場合 sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //  編集可能にする場合はYES
        imagePicker.allowsEditing = YES;
        //  自分への通知設定
        imagePicker.delegate = self;
        
        //      フォトライブラリを開く
        [self presentViewController:imagePicker animated:YES
                         completion:^{
                             //     開いたタイミングに呼ばれる
                         }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
