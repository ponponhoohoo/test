//
//  ViewController.m
//  CameraTest1
//
//  Created by Takashi Ohtsuka on 2013/05/22.
//  Copyright (c) 2013年 takatronix.com. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CustomView.h"
#define IMAGE_HEIGHT 60
#define IMAGE_WIDTH 80
#define SPACE_WIDTH 20
#define NUMBER_OF_VIEWS 8
#define DEFAULT_VAL 0
#import "MyScrollView.h"
#import "MenuView.h"
#import "SubMenuView.h"

@interface ViewController ()<MenuViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) MenuView *menuView;
@property (strong, nonatomic) SubMenuView *submenuView;
@property(nonatomic, strong) GPUImageStillCamera *stillCamera;
@property(nonatomic, strong) GPUImageFilter *filter;
@property(nonatomic, strong) GPUImageFilterGroup *filterGroup;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.ImagePanel  = [[UIScrollView alloc] init];
    
    // スクロールビューのサイズを指定
    self.ImagePanel.frame = CGRectMake(10, 10, 300, 300);
    // メニュービュー
    self.menuView = [[[NSBundle mainBundle] loadNibNamed:@"MenuView"
                                                   owner:self
                                                 options:nil] lastObject];
    self.menuView.delegate = self;
    [self.view addSubview:self.menuView];
    
    // メニュービュー
    self.submenuView = [[[NSBundle mainBundle] loadNibNamed:@"SubMenuView"
                                                   owner:self
                                                 options:nil] lastObject];
    self.submenuView.delegate = self;
    [self.view addSubview:self.submenuView];
    self.MainImage = [[GestureImageView alloc] initWithFrame:
                                   CGRectMake(10, 10, 300, 300)];
    /*
    // スタンプの表示パネル生成
    UIView *stampPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 320, 300)];
    stampPanel.backgroundColor = [UIColor lightGrayColor];
    _stampPanel = stampPanel;
    [self.view addSubview:_stampPanel];
    
    // スタンプの表示パネルの、クローズボタンを生成
    UIButton *stampPanelClose = [[UIButton alloc] initWithFrame:CGRectMake(275, 5, 40, 40)];
    stampPanelClose.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"stamp.png"]];
    [stampPanelClose addTarget:self action:@selector(stampPanelClose:) forControlEvents:UIControlEventTouchUpInside];
    [_stampPanel addSubview:stampPanelClose];
    
    // スタンプ生成ボタン
    UIButton *stampThumb1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
    stampThumb1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"stamp.png"]];
    //stampThumb1.delegate = self;
    [stampThumb1 addTarget:self action:@selector(stampMake1:) forControlEvents:UIControlEventTouchUpInside];
    _stampThumb1 = stampThumb1;
    [_stampPanel addSubview:_stampThumb1];
    
    stampPanel.hidden = YES;
    */
    self.stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    
    CGRect scrollViewFrame = self.scrollView.frame;
	CGSize scrollViewSize = scrollViewFrame.size;
	scrollViewFrame.origin.x -= SPACE_WIDTH/2;
	scrollViewFrame.size.width += SPACE_WIDTH;
	self.scrollView.frame = scrollViewFrame;
	self.scrollView.contentSize = CGSizeMake((IMAGE_WIDTH+SPACE_WIDTH)*NUMBER_OF_VIEWS, scrollViewSize.height);
	self.scrollView.pagingEnabled = NO;
	self.scrollView.clipsToBounds = YES;
    NSLog(@"%f",scrollViewSize.width);
	CGFloat x = 0;
    int cnt = 1;
	for (int i=0; i < NUMBER_OF_VIEWS; i++) {
		
		// left space
		x += SPACE_WIDTH/2.0;
        
		// content
		CGRect rect = CGRectMake(x, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
        //UIImage作成
        UIImage* image = [UIImage imageNamed:
                          [NSString stringWithFormat:@"image%02ds.jpg", i+1]];
        
        //UIImageView作成
        self.ThumView =[[UIImageView alloc]initWithImage:image];
        self.ThumView.userInteractionEnabled = YES;
        
        CGRect i_rect = CGRectMake(i * 100, 0, 80, 80);
        self.ThumView.frame = i_rect;
  //      [c_view addSubview:imageView];
        self.ThumView.tag = cnt;
		[self.scrollView addSubview:self.ThumView];
		x += rect.size.width;
        
		// right space
		x += SPACE_WIDTH/2.0;
        cnt++;
	}
    self.MainImage.image = self.Original;
    [self.view addSubview:self.ImagePanel];
    [self.ImagePanel addSubview:self.MainImage];
    self.ImagePanel.contentSize = self.MainImage.bounds.size;
}

- (void)showOverlayView
{
    self.overlayView.hidden = NO;
    
    [UIView animateWithDuration:0.3f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.overlayView.alpha = 0.5;
                     }
                     completion:^(BOOL finished){
                     }];
    
    [UIView commitAnimations];
}

- (IBAction)tappedMenuButton:(id)sender
{
   // [self.submenuView openMenuView];
    
    if (self.menuView.isMenuOpen) {

    NSLog(@"11111");
        [self.menuView closeMenuView];
    } else {
        NSLog(@"2222");

        [self.menuView openMenuView];
      //  [self.submenuView closeMenuView];
    }

}

- (IBAction)tappedSubMenuButton:(id)sender
{
    if (self.submenuView.isMenuOpen) {
        self.submenuView.hidden = YES;
        [self.submenuView closeMenuView];
    } else {
        NSLog(@"2222");
        [self.submenuView openMenuView];
    }
   // [self.submenuView openMenuView];
   // [self.submenuView tappedMenuButton];
}

- (void)Brightness:(MenuView *)menuView type:(float)num {
    UIImage *inputImage = self.Original;
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:inputImage];
    CIFilter *ciFilter = [CIFilter filterWithName:@"CIColorControls"
                                    keysAndValues:kCIInputImageKey, ciImage,
                          @"inputBrightness",[NSNumber numberWithFloat:num], nil];
    
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
    UIImage* newImage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:UIImageOrientationUp];
    CGImageRelease(cgimg);

    self.MainImage.image = newImage;
}

- (void)menuViewDidSelectedItem:(MenuView *)menuView type:(MenuViewSelectedItemType)type
{
    switch (type) {
        case MenuViewSelectedItemTypeLeft:
            NSLog(@"LeftButton");
            break;
            
        case MenuViewSelectedItemTypeCenter:
            NSLog(@"CenterButton");
            break;
            
        case MenuViewSelectedItemTypeRight:
        default:

             NSLog(@"RightButton");
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//      フォトライブラリを開く
- (IBAction)ReturnPage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (IBAction)SaveImage:(id)sender {
    // 描画領域の設定
    CGSize size = CGSizeMake(self.MainImage.frame.size.width , self.MainImage.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    // グラフィックスコンテキスト取得
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // コンテキストの位置を切り取り開始位置に合わせる
    CGPoint point = self.MainImage.frame.origin;
    CGAffineTransform affineMoveLeftTop
    = CGAffineTransformMakeTranslation(
                                       -(int)point.x ,
                                       -(int)point.y );
    CGContextConcatCTM(context , affineMoveLeftTop );
    
    // viewから切り取る
    [(CALayer*)self.view.layer renderInContext:context];
    
    // 切り取った内容をUIImageとして取得
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
 //   UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, NULL);
    // コンテキスト終了
    UIGraphicsEndImageContext();
    //      カメラロールへ保存する
    UIImageWriteToSavedPhotosAlbum(viewImage, self,  @selector(image:didFinishSavingWithError:contextInfo:), nil);

}


//      写真撮影後orサムネイル選択後に呼ばれる処理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//       オリジナル画像
	UIImage* originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    self.Original = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
	//       編集画像
	UIImage* editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImage* savedImage;
    if(editedImage){
        savedImage = editedImage;
    }
    else{
        savedImage = originalImage;
    }
    
    
    //      モノクロフィルタ＋ケラレフィルタを適用し、画面に表示
    // self.imageView.image = [self vignetteFilter:[self monochromeFilter:savedImage]];
    
    // 画像を取得
    UIImage *inputImage = savedImage;
    
    // GPUImageのフォーマットにする
    GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:inputImage];
    
    // フィルター
    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    GPUImageSobelEdgeDetectionFilter *sobelFilter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
    // イメージにセピアフィルターを加える
    [imagePicture addTarget:sepiaFilter];
    
    //フィルターグループ
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    [filterGroup addFilter:sobelFilter];
    [filterGroup addFilter:sepiaFilter];
    [filterGroup setInitialFilters:@[sobelFilter]];
    [filterGroup setTerminalFilter:sepiaFilter];
    
    [sobelFilter addTarget:sepiaFilter];
    [imagePicture addTarget:filterGroup];
    
    // フィルター実行
    [imagePicture processImage];
    // フィルターから画像を取得
    UIImage *outputImage = [sepiaFilter imageFromCurrentlyProcessedOutput];
    
    // 画像を表示
    self.MainImage.image = outputImage;
    
    
    //      カメラロールへ保存する
//    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self,  @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
    //      開いているカメラ・フォトライブラリを閉じる
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if(error){
        NSLog(@"Error");
    }else{
        NSLog(@"保存した");
    }
}


//      モノクロフィルタ
-(UIImage*)monochromeFilter:(UIImage*)image{
    
    // UIImageをCoreImageに変換する
    CIImage* ciImage = [[CIImage alloc] initWithImage:image];
    
    
    //  CoreImageフィルタを作成する
    CIFilter* ciFilter = [CIFilter filterWithName:@"CIColorMonochrome"
                                    keysAndValues:kCIInputImageKey, ciImage,
                          // パラメータ：入力色（RGBのフィルタ係数）
                          // セピア色にするなら [CIColor colorWithRed:1.0 green:0.7 blue:0.4]
                          @"inputColor", [CIColor colorWithRed:1.0 green:1.0 blue:1.0],
                          // パラメータ(度合い)
                          // 0.5にすれば半分の適用度になります
                          @"inputIntensity", [NSNumber numberWithFloat:1.0],
                          nil];
    
    //      CoreImageのコンテクストを作成
    CIContext* ciContext = [CIContext contextWithOptions:nil];
    //      フィルタを適用
    CGImageRef cgImage = [ciContext createCGImage:ciFilter.outputImage fromRect:[ciFilter.outputImage extent]];
    //     CGImageRefをUIImageに変換
    UIImage* retImage = [UIImage imageWithCGImage:cgImage scale:image.scale orientation:UIImageOrientationUp];
    //      CGImage開放
    CGImageRelease(cgImage);
    
    
    return retImage;
}

//      ケラレフィルタ（カメラの周辺光量落ち)
-(UIImage*)vignetteFilter:(UIImage*) image{
    
    // UIImageをCoreImageに変換する
    CIImage* ciImage = [[CIImage alloc] initWithImage:image];
    
    
    //  CoreImageフィルタを作成する
    CIFilter* ciFilter = [CIFilter filterWithName:@"CIVignette"
                                    keysAndValues:kCIInputImageKey, ciImage,
                          
                          //
                          @"inputRadius", [NSNumber numberWithFloat:2.0],
                          // パラメータ(度合い)
                          // 0.5にすれば半分の適用度になります
                          @"inputIntensity", [NSNumber numberWithFloat:1.0],
                          nil];
    
    //      CoreImageのコンテクストを作成
    CIContext* ciContext = [CIContext contextWithOptions:nil];
    //      フィルタを適用
    CGImageRef cgImage = [ciContext createCGImage:ciFilter.outputImage fromRect:[ciFilter.outputImage extent]];
    //     CGImageRefをUIImageに変換
    UIImage* retImage = [UIImage imageWithCGImage:cgImage scale:image.scale orientation:UIImageOrientationUp];
    //      CGImage開放
    CGImageRelease(cgImage);
    
    
    return retImage;
    
}

- (void) touchesBegan:(NSSet *) touches withEvent: (UIEvent *) event
{
	UITouch * touch = [[event allTouches] anyObject];
    //NSLog(@"tag=%d",touch.view.tag);
	if (touch.view.tag == 1) {
        if (sepia_flg == false) {
		// GPUImageのフォーマットにする
        GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:self.imageView.image];
        
        /*
        // フィルター
        GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
        GPUImageSobelEdgeDetectionFilter *sobelFilter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
        // イメージにセピアフィルターを加える
        [imagePicture addTarget:sepiaFilter];
        
        //フィルターグループ
        GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
        [filterGroup addFilter:sobelFilter];
        [filterGroup addFilter:sepiaFilter];
        [filterGroup setInitialFilters:@[sobelFilter]];
        [filterGroup setTerminalFilter:sepiaFilter];
        
        [sobelFilter addTarget:sepiaFilter];
        [imagePicture addTarget:filterGroup];
        */
        
        // セピアフィルターを作る
        GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
        
        // イメージをセピアフィルターにくっつける
        [imagePicture addTarget:sepiaFilter];

        // フィルター実行
        [imagePicture processImage];
        // フィルターから画像を取得
        UIImage *outputImage = [sepiaFilter imageFromCurrentlyProcessedOutput];
        self.MainImage.image = outputImage;
        sepia_flg = true;
        // 画像を表示
        }
        
	} else if (touch.view.tag == 2) {
        // GPUImageのフォーマットにする
        GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:self.MainImage.image];

        // セピアフィルターを作る
        GPUImageHalftoneFilter *sepiaFilter = [[GPUImageHalftoneFilter alloc] init];
        
        // イメージをセピアフィルターにくっつける
        [imagePicture addTarget:sepiaFilter];
        
        // フィルター実行
        [imagePicture processImage];
        // フィルターから画像を取得
        UIImage *outputImage = [sepiaFilter imageFromCurrentlyProcessedOutput];
        self.MainImage.image = outputImage;
        sepia_flg = true;

    } else if (touch.view.tag == 3) {
        self.MainImage.image = self.Original;
        sepia_flg = false;
        gray_flg = false;
        bright_flg = false;
    }

}

- (IBAction)pressBtn:(id)sender {
    
    //トランスフォーム取得
    CGAffineTransform revs = self.imageView.transform;
    
    //-1, -1に指定すると反転
    revs = CGAffineTransformScale( revs, -1, 1);
    
    // transformの内容（反転）を設定
    self.imageView.transform = revs;
    
}

- (IBAction)SwitchView:(id)sender {

    
}

- (IBAction)stampPanelBtn:(id)sender {
    
    // 位置の指定
    _stampPanel.center = CGPointMake(160, 800);
    // スタンプパネルの表示
    _stampPanel.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];  // 条件指定開始
    [UIView setAnimationDuration:0.4];  // アニメーションにかける秒数
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  // アニメーションのイージング
    _stampPanel.center = CGPointMake(160, 370);  // 終了位置指定
    [UIView commitAnimations];  // アニメーション開始
    
    // 重なり順を一番前へ
    [self.view bringSubviewToFront:_stampPanel];
}

-(void)stampPanelClose:(UIButton*)stampPanelCloseBtn{
    
    // スタンプパネルを隠す
    [UIView beginAnimations:nil context:nil];  // 条件指定開始
    [UIView setAnimationDuration:0.4];  // アニメーションにかける秒数
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  // アニメーションのイージング
    _stampPanel.center = CGPointMake(160, 800);  // 終了位置指定
    [UIView commitAnimations];  // アニメーション開始
    
}

-(void)stampMake1:(UIButton*)stamp1{
    //スタンプを生成
    
    StampView *stampView = [[StampView alloc] initWithFrame:CGRectMake(50, 50, 150, 150)];
    stampView.delegate = self;
    [stampView setImage:[UIImage imageNamed:@"stamp.png"]];
    [self.StampDisplayView addSubview:stampView];
}

/*
//タッチ維持のまま指を動かしたときに呼び出される
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved:");
}
//タッチした指が離れたときに呼び出される
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded:");
}

//タッチ処理が中断されたときに呼び出される
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled:");
}
*/
@end
