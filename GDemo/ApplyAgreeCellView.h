//
//  ApplyAgreeCellView.h
//  GDemo
//
//  Created by Wingle Wong on 8/17/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "GDUserInfo.h"

@protocol ApplyAgreeDelegate <NSObject>

- (void)agreeUser:(GDUserInfo *) user;
- (void)disagreeUser:(GDUserInfo *) user;

@end

@interface ApplyAgreeCellView : UIView
@property (nonatomic, assign) id <ApplyAgreeDelegate> delegate;
@property (nonatomic, retain) GDUserInfo *userInfo;
@property (retain, nonatomic) IBOutlet EGOImageButton *imgBtn;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

+ (ApplyAgreeCellView *) cellView;

- (IBAction)agreeBtnClick:(id)sender;
- (IBAction)disAgreeBtnClick:(id)sender;

- (void) setUserInfo:(GDUserInfo *)user withIndexPath:(NSIndexPath *) indexPath;

@end
