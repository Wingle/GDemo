//
//  DistrubiteViewController.h
//  GDemo
//
//  Created by Wingle Wong on 8/16/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@class PengyouquanDataModel;

@protocol DistrubiteDelegate <NSObject>

- (void) FinishedDistrubite:(PengyouquanDataModel *) model;

@end

@interface DistrubiteViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (assign, nonatomic) id <DistrubiteDelegate> delegate;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScollView;
@property (retain, nonatomic) IBOutlet UITextField *contentTextField;
@property (retain, nonatomic) IBOutlet UIButton *imgBtn;
- (IBAction)imgBtnClick:(id)sender;

@end
