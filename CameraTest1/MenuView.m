//
//  MenuView.m
//  TopSlideMenuSample
//
//  Created by hiraya.shingo on 2014/03/19.
//  Copyright (c) 2014年 hiraya.shingo. All rights reserved.
//

#import "MenuView.h"
#define DEFAULT_VAL 0
@interface MenuView ()

@property (assign, nonatomic, readwrite) BOOL isMenuOpen;

@end

@implementation MenuView

#pragma mark - UIView methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.Brightsw.minimumValue = -0.4;  // 最小値を0に設定
    self.Brightsw.maximumValue = 0.4;  // 最大値を500に設定
    self.Brightsw.value = DEFAULT_VAL;  // 初期値を250に設定
    // 値が変更された時にhogeメソッドを呼び出す
    [self.Brightsw addTarget:self action:@selector(Changebright:)
 forControlEvents:UIControlEventValueChanged];

    self.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height + 60.0, self.frame.size.width, self.frame.size.height);
  //  self.isMenuOpen = YES;
}

#pragma mark - public methods

- (void)tappedMenuButton
{
    if (self.isMenuOpen) {
         NSLog(@"2222");
        [self closeMenuView];
        self.hidden = YES;
    } else {
        [self openMenuView];

    }
}

#pragma mark - private methods

/**
 *  close MenuView
 */
- (void)closeMenuView
{
    // Set new origin of menu
    self.isMenuOpen = NO;
    CGRect menuFrame = self.frame;
    menuFrame.origin.y = [[UIScreen mainScreen] bounds].size.height - 60.0;
    [UIView animateWithDuration:0.3f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = menuFrame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    [UIView commitAnimations];
}

/**
 *  open MenuView
 */
- (void)openMenuView
{
    // Set new origin of menu
    self.isMenuOpen = YES;
    CGRect menuFrame = self.frame;
    menuFrame.origin.y = [[UIScreen mainScreen] bounds].size.height + 60.0;
    
    [UIView animateWithDuration:0.3f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = menuFrame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [UIView commitAnimations];
}

- (void)Changebright:(id)sender {
    
    //スライダーの値を取得
    float slValue = 0;
    slValue = self.Brightsw.value;
    [self.delegate Brightness:self type:slValue];
}

- (void)tappedButtonWithType:(MenuViewSelectedItemType)type
{
    if ([self.delegate respondsToSelector:@selector(menuViewDidSelectedItem:type:)]) {
        [self.delegate menuViewDidSelectedItem:self type:type];
    }
    [self closeMenuView];
}

#pragma mark - Action methods

- (IBAction)tappedLeftButton:(id)sender
{
    [self tappedButtonWithType:MenuViewSelectedItemTypeLeft];
}

- (IBAction)tappedCenterButton:(id)sender
{
    [self tappedButtonWithType:MenuViewSelectedItemTypeCenter];
}

- (IBAction)tappedRightButton:(id)sender
{
    [self tappedButtonWithType:MenuViewSelectedItemTypeRight];
}

@end
