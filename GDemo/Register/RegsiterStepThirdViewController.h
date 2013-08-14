//
//  RegsiterStepThirdViewController.h
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@protocol FillInBlankDelegate;


@interface RegsiterStepThirdViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, FillInBlankDelegate>
@property (retain, nonatomic) IBOutlet EGOImageButton *imageBtn;
@property (retain, nonatomic) IBOutlet UITextField *nickNameTextFiled;
@property (retain, nonatomic) IBOutlet UITextField *phoneTextField;
@property (retain, nonatomic) IBOutlet UIButton *ganderBtn;
@property (retain, nonatomic) IBOutlet UIButton *gameBtn;
@property (retain, nonatomic) IBOutlet UIButton *signBtn;
@property (retain, nonatomic) IBOutlet UIButton *areaBtn;



- (IBAction)imageBtnClick:(id)sender;
- (IBAction)genderBtnClick:(id)sender;
- (IBAction)gameBtnClick:(id)sender;
- (IBAction)signBtnClick:(id)sender;
- (IBAction)areaBtnClick:(id)sender;

@end
