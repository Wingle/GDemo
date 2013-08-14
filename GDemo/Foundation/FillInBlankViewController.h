//
//  FillInBlankViewController.h
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FillInBlankDelegate <NSObject>

- (void) fillInBlankFinished:(NSString *) text;

@end

@interface FillInBlankViewController : UIViewController
@property (nonatomic, assign) id <FillInBlankDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITextView *fillTextView;
@end
