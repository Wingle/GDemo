//
//  GDUserInfoViewController.h
//  GDemo
//
//  Created by Wingle Wong on 8/17/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "EGOImageView.h"
#import "GDUserInfo.h"

@interface GDUserInfoViewController : UIViewController
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScrollView;
@property (retain, nonatomic) IBOutlet UIView *contactView;
@property (retain, nonatomic) IBOutlet EGOImageView *imgView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *genderLabel;
@property (retain, nonatomic) IBOutlet UILabel *areaLabel;
@property (retain, nonatomic) IBOutlet UILabel *gameLabel;
@property (retain, nonatomic) IBOutlet UILabel *signLabel;
@property (nonatomic, retain) GDUserInfo *userInfo;
@property (retain, nonatomic) IBOutlet UIButton *sendMsgBtn;





- (IBAction)sendMsgBtnClick:(id)sender;

@end
