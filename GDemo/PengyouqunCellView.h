//
//  PengyouqunCellView.h
//  GDemo
//
//  Created by Wingle Wong on 8/15/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "EGOImageView.h"

@interface PengyouqunCellView : UIView
@property (retain, nonatomic) IBOutlet EGOImageButton *headImgBtn;
@property (retain, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet EGOImageView *contentImgView;
@property (retain, nonatomic) IBOutlet UILabel *newDateLabel;

+ (PengyouqunCellView *) cellView;

@end
