//
//  HeadImageCellView.h
//  GDemo
//
//  Created by Wingle Wong on 8/14/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface HeadImageCellView : UIView
@property (retain, nonatomic) IBOutlet EGOImageButton *imageBtn;
- (IBAction)imageBtnClick:(id)sender;

@end
