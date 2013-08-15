//
//  FillInBlankViewController.h
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FillInBlankDelegate <NSObject>

- (void) fillInBlankFinished:(UITextField *) textField;

@end

@interface FillInBlankViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, assign) id <FillInBlankDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITextField *fillTextFiled;
@property (nonatomic, assign) NSInteger textTag;

@end
